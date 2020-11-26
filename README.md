# ReachabilityObserver

![Swift](https://img.shields.io/badge/Swift-4.2-orange.svg)
[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat)](https://github.com/nibdevn/ReachabilityObserver/blob/master/LICENSE)

## Summary

- [Requirements](#requirements)
- [Dependency](#dependency)
- [Usage](#usage)
- [Installation](#installation)
- [Example](#example)

## Requirements

- Swift 4.2
- iOS 10.0+

## Dependency
 - [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift)
 
## Usage

```swift

var disposeBag: ReachabilityDisposeBag?

disposeBag = ReachabilityObserver.subscribe { status in
    switch status {    
    case .none:
        print("ReachabilityStatus is None")
    case .cellular:
        print("ReachabilityStatus is Cellular")
    case .wifi:
        print("ReachabilityStatus is Wifi")
    }
}

disposeBag?.dispose()

```

## Installation

ReachabilityObserver is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby

pod 'ReachabilityObserver', :tag => '1.0.0', :git => 'https://github.com/nibdevn/ReachabilityObserver'

```

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## License

These works are available under the MIT license. See the [LICENSE][license] file
for more info.

[license]: LICENSE
