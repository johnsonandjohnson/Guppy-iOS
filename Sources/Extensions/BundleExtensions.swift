//
//  BundleExtensions.swift
//
//  Copyright © 2020 Johnson & Johnson
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

private class BundleFinder {}

extension Foundation.Bundle {
    
    /**
     The resource bundle associated with the current module..
     - important: When `Guppy` is distributed via Swift Package Manager, it will be synthesized automatically in the name of `Bundle.module`.
     */
    static var resource: Bundle = {
        let moduleName = "Guppy"
        #if COCOAPODS
        let bundleName = moduleName
        #else
        let bundleName = "\(moduleName)_\(moduleName)"
        #endif
        
        let candidates = [
            // Bundle should be present here when the package is linked into an App.
            Bundle.main.resourceURL,
            
            // Bundle should be present here when the package is linked into a framework.
            Bundle(for: BundleFinder.self).resourceURL,
            
            // For command-line tools.
            Bundle.main.bundleURL
        ]
        
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }
        
        fatalError("Unable to find bundle named \(bundleName)")
    }()
}
