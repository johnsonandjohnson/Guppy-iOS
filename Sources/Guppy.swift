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

import Foundation
import UIKit

public class Guppy {

    // MARK: - Public

    public var showOnShake = true
    
    public static let shared = Guppy()

    /// Registers custom URLProtocol. If you are you using a custom URLSession add **GuppyURLProtocol.self** to your URLSessionConfiguration's protocolClasses
    public static func registerURLProtocol() {
        URLProtocol.registerClass(GuppyURLProtocol.self)
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
        guard var topViewController = UIApplication.shared.firstKeyWindow?.rootViewController else {
            assertionFailure("Could not find root view controller")
            return
        }

        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }

        // If Guppy is already being displayed, we can return and ignore
        if let navController = topViewController as? NavigationController, navController.viewControllers.first is LogTableViewController {
            return
        }

        logTableViewController = LogTableViewController.instantiateFromStoryboard()

        guard let logTableViewController = logTableViewController else {
            assertionFailure("Failed to load from storyboard")
            return
        }

        logTableViewController.logItems = Guppy.shared.logItems

        let navigationController = NavigationController(rootViewController: logTableViewController)
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

    // Prevent initialization of singleton
    private init() {
        configureAppearance()
    }

    private func configureAppearance() {
        let instances = [NavigationController.self]
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = Colors.NavigationBar.lightBlue
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance(whenContainedInInstancesOf: instances).standardAppearance = navBarAppearance
        UINavigationBar.appearance(whenContainedInInstancesOf: instances).scrollEdgeAppearance = navBarAppearance

        UIBarButtonItem.appearance(whenContainedInInstancesOf: instances).tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: instances).backgroundColor = .white
    }
}
