import Foundation
import Reachability

public typealias ReachabilityStatusHandler = ((ReachabilityObserver.ReachabilityStatus) -> Void)

final public class ReachabilityObserver {
    
    public enum ReachabilityStatus : CaseIterable {
        case none
        case cellular
        case wifi
    }
    
    // MARK: - Con(De)structor
    private init() {
        do {
            m_reachability = try Reachability()
            if let reachability = m_reachability {
                try! reachability.startNotifier()
                m_isInActive = false
                switch reachability.connection {
                case .cellular: m_status = .cellular
                case .wifi: m_status = .wifi
                default: m_status = .none
                }
                post(reachability)
            }
        }catch {
            m_isInActive = true
            m_reachability = nil
        }
    }
    
    deinit {
        if let reachability = m_reachability {
            reachability.stopNotifier()
        }
    }
    
    // MARK: - Properties
    public static let shared = ReachabilityObserver()
    
    private let m_reachability: Reachability?
    private var m_isInActive: Bool = true
    private var m_status: ReachabilityStatus = .none
    
    public var status: ReachabilityStatus { return m_status }
    public var isNetworkConnected: Bool { return status != .none }
    public var isActive: Bool { return !m_isInActive }
    
    fileprivate let notificationCenter: NotificationCenter = NotificationCenter()
    fileprivate var disposeBagSet: Set<ReachabilityDisposeBag> = Set<ReachabilityDisposeBag>()
    fileprivate var notificationNameRawValue: String = "com.nib.reachability.observer.reachability.status.event.notification"
    fileprivate var notificationStatusInfo: String = "com.nib.reachability.observer.reachability.status.event"
    fileprivate var notificationName: Notification.Name { Notification.Name(rawValue: notificationNameRawValue) }
    fileprivate var notification: Notification {
        Notification(name: notificationName, object: nil, userInfo: [notificationStatusInfo : self.status])
    }
    
    // MARK: - Private Methods
    private func post(_ service: Reachability) {
        service.whenReachable = { reachability in
            self.m_status = reachability.connection == .wifi ? .wifi : .cellular
            self.notificationCenter.post(self.notification)
        }
        
        service.whenUnreachable = { _ in
            self.m_status = .none
            self.notificationCenter.post(self.notification)
        }
    }
    
    @discardableResult
    public static func subscribe(_ handler: @escaping (ReachabilityStatus) -> Void) -> ReachabilityDisposeBag? {
        guard shared.isActive else { return nil }
        let disposeBag = ReachabilityDisposeBag(handler)
        shared.disposeBagSet.insert(disposeBag)
        shared.notificationCenter.addObserver(disposeBag, selector: #selector(disposeBag.event(_:)), name: shared.notificationName, object: nil)
        return disposeBag
    }
}

public class ReachabilityDisposeBag: NSObject {
    
    private weak var observer: ReachabilityObserver?
    private var handler: ReachabilityStatusHandler?
    
    fileprivate init(_ handler: @escaping ReachabilityStatusHandler) {
        self.observer = ReachabilityObserver.shared
        self.handler = handler
    }
    
    @objc fileprivate func event(_ notification: Notification) {
        guard let userInfo = notification.userInfo, let status = userInfo[ReachabilityObserver.shared.notificationStatusInfo] as? ReachabilityObserver.ReachabilityStatus else { return }
        handler?(status)
    }
    
    public func dispose() {
        self.observer?.disposeBagSet.remove(self)
        ReachabilityObserver.shared.notificationCenter.removeObserver(self, name: ReachabilityObserver.shared.notificationName, object: nil)
        self.observer = nil
        self.handler = nil
    }
}

