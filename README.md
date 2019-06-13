![Guppy](https://raw.githubusercontent.com/johnsonandjohnson/Guppy/master/Screenshots/Guppy.png)

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
        configuration.protocolClasses = [MyCustomProtocol, Guppy.getSniffURLProtocol()]
        
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
        configuration.protocolClasses = [Guppy.getSniffURLProtocol()]
        
        super.init(configuration: configuration)
    }
}
```


## Requirements

Xcode 10.2+
iOS 10.0+

## Installation

```ruby
pod 'Guppy'
```

## License

Guppy is released under the Apache 2.0 license. [See LICENSE](https://github.com/johnsonandjohnson/Guppy/blob/master/LICENSE) for details.
