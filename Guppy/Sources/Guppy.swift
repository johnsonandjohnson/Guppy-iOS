//
//  Guppy.swift
//
//  Copyright © 2019 Johnson & Johnson
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

public class Guppy {

    // MARK: - Public

    public var showOnShake = true
    
    public static let shared = Guppy()

    /// Registers custom URLProtocol. If you are you using a custom URLSession use **getSniffURLProtocol()** and add it to your URLSessionConfiguration's protocolClasses
    public static func registerURLProtocol() {
        URLProtocol.registerClass(SniffURLProtocol.self)
    }

    /// Using configuration.protocolClasses.append(getSniffURLProtocol().self) might not work if you have a URLProtocol already in the protocolClass array. It is recommend to create a new AnyClass array and set it to protocolClasses.
    ///
    /// - Returns: Custom url protocol as AnyClass and can be added to a URLSessionConfiguration's protocol classes.
    public static func getSniffURLProtocol() -> AnyClass {
        return SniffURLProtocol.self
    }

    public func getAllLogs() -> [LogItem] {
        return logItems
    }

    public func removeAllLogs() {
        logItems.removeAll()
    }

    public func log(_ logItem: LogItem) {
        logItems.append(logItem)
    }

    public func presentLogViewController() {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else {
            assertionFailure("Could not find root view controller")
            return
        }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        // If Guppy is already being displayed, we can return and ignore
        if let navController = topViewController as? UINavigationController, navController.viewControllers.first is LogTableViewController {
            return
        }

        logTableViewController = LogTableViewController.instantiateFromStoryboard()

        guard let logTableViewController = logTableViewController else {
            assertionFailure("Failed to load from storyboard")
            return
        }

        logTableViewController.logItems = Guppy.shared.logItems

        let navigationController = UINavigationController(rootViewController: logTableViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.modalPresentationCapturesStatusBarAppearance = true
        topViewController.present(navigationController, animated: true)
    }

    // MARK: - Internal

    private weak var logTableViewController: LogTableViewController?

    /// queue for synchronizing access to logItems for thread safety
    private let logItemsAccessQueue = DispatchQueue(label: "LogItemsAccessQueue", attributes: .concurrent)

    private var _logItems: [LogItem] = [] {
        didSet {
            if Guppy.shared.logTableViewController != nil {
                DispatchQueue.main.async {
                    Guppy.shared.logTableViewController?.logItems = self.logItems
                }
            }
        }
    }

    public var logItems: [LogItem] {
        get {
            return logItemsAccessQueue.sync {
                return _logItems
            }
        }
        set {
            logItemsAccessQueue.async(flags: .barrier) {
                self._logItems = newValue
            }
        }
    }

    private init() {
        // Prevent initialization of singleton
    }
}
