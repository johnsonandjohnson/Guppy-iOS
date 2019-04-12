//
//  AirDropTextDataSource.swift
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

class AirDropTextDataSource: NSObject, UIActivityItemSource {
    
    let shareText: String
    
    init(with shareText: String) {
        self.shareText = shareText
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return NSTemporaryDirectory()
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let fileName = "GuppyLog-\(DateFormat.format(Date(), with: "MM-dd-yyyy-hh-mm-ss")).txt"
        if activityType == .airDrop {
            FileManager.default.createGuppyFolder()
            if let fullURL = URL(string: "\(FileManager.guppyDir.absoluteString)\(fileName)") {
                do {
                    try shareText.data(using: .utf8)?.write(to: fullURL)
                    return fullURL
                } catch {
                    assertionFailure("Couldn't write to Guppy log file")
                }
            }
        }
        return shareText
    }
}
