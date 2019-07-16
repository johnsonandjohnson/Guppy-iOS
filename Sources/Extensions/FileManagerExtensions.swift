//
//  FileManagerExtensions.swift
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

extension FileManager {
    
    static let guppyDir = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("Guppy", isDirectory: true)
    
    func createGuppyFolder() {
        do {
            try FileManager.default.createDirectory(at: FileManager.guppyDir, withIntermediateDirectories: true, attributes: nil)
        } catch {
            assertionFailure("Could not create Guppy folder")
        }
    }
    
    func clearGuppyLog() {
        try? FileManager.default.removeItem(at: FileManager.guppyDir)
    }
}
