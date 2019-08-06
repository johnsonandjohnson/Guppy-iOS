![Guppy](https://raw.githubusercontent.com/johnsonandjohnson/Guppy/master/Screenshots/Guppy.png)

[![Platform](https://img.shields.io/badge/platform-iOS-green.svg?style=flat)](https://img.shields.io/badge/platform-iOS-blue.svg?style=flat)
[![Swift Version](https://img.shields.io/badge/Swift-5.0+-F16D39.svg?style=flat)](https://developer.apple.com/swift)
[![CocoaPods](https://img.shields.io/cocoapods/v/Guppy.svg?style=flat)](https://cocoapods.org/pods/Guppy)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![codecov](https://codecov.io/gh/johnsonandjohnson/Guppy/branch/master/graph/badge.svg)](https://codecov.io/gh/johnsonandjohnson/Guppy)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

Do you want to know what's tedious? Debugging network requests and responses if you don't have the right tools. Guppy is a logging tool focused on HTTP requests that can be easily plugged into any iOS application. Guppy will intercept and log each network request sent from the app. You can access any Guppy log and share it with the rest of your team effortlessly.

## Usage

While in the simulator you can use: `^ + ⌘ + z` to bring up Guppy or shake your phone.

![Routes](https://raw.githubusercontent.com/johnsonandjohnson/Guppy/master/Screenshots/Routes.png)


You can dig deep into the details of your network logs and share them with your team or yourself.

![Details](https://raw.githubusercontent.com/johnsonandjohnson/Guppy/master/Screenshots/Details.png) 


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### URLSession

```swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Guppy.registerURLProtocol()
        
        return true
    }
}
```

### URLSession with Custom Protocols

```swift 
class Session: URLSession {
    
    init() {
        let configuration = URLSessionConfiguration.default
        
        configuration.urlCache = nil
        
        // Protocols are evaluated in reverse order
        // If GuppyURLProtocol is not the last protocol it is not guaranteed to be executed
        configuration.protocolClasses = [MyCustomProtocol, GuppyURLProtocol.self]
        
        super.init(configuration: configuration)
    }
}

```

### Alamofire

```swift 
class SessionManager: Alamofire.SessionManager {

    init() {
        let configuration = URLSessionConfiguration.default

        configuration.urlCache = nil
        configuration.protocolClasses = [GuppyURLProtocol.self]
        
        super.init(configuration: configuration)
    }
}
```


## Requirements

Xcode 10.2+
iOS 10.0+

## Installation

Guppy is best used in non-production environments. By default, installing the Guppy framework will automatically make it available when the user shakes their device. To avoid this do any combination of the following:
* If you are using multiple targets for different environments, only include the Guppy framework in the non-production targets
* If you are using one target with multiple configurations for different environments, only include the Guppy framework in the non-production configuration
* Set `Guppy.shared.showOnShake = false` in your `didFinishLaunchingWithOptions` for the specific times where Guppy should not be available

### [CocoaPods](https://cocoapods.org)

```ruby
pod 'Guppy'
```

### [Carthage](https://github.com/Carthage/Carthage)

```
github "johnsonandjohnson/Guppy"
```

## License

Guppy is released under the Apache 2.0 license. See [LICENSE](https://github.com/johnsonandjohnson/Guppy/blob/master/LICENSE) for details.
