//
//  ViewController.swift
//  ReachabilityObserver
//
//  Created by nibdevn@gmail.com on 11/26/2020.
//  Copyright (c) 2020 nibdevn@gmail.com. All rights reserved.
//

import UIKit
import ReachabilityObserver

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    var disposeBag: ReachabilityDisposeBag?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onTappedSubscribeButton(_ sender: UIButton) {
        disposeBag?.dispose()
        disposeBag = ReachabilityObserver.subscribe { (status) in
            switch status {
            case .none:
                self.statusLabel.text = "None"
            case .cellular:
                self.statusLabel.text = "Cellular"
            case .wifi:
                self.statusLabel.text = "Wifi"
            }
        }
    }

    @IBAction func onTappedDisposeButton(_ sender: UIButton) {
        disposeBag?.dispose()
        statusLabel.text = "Disposed"
    }
}
