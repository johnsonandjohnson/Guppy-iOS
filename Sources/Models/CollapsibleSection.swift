//
//  CollapsibleSection.swift
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

class CollapsibleSection<T> {
    
    let title: String
    let rows: [T]
    var isCollapsed: Bool
    
    init(title: String, rows: [T], isCollapsed: Bool) {
        self.title = title
        self.rows = rows
        self.isCollapsed = isCollapsed
    }
}

extension Sequence where Iterator.Element == CollapsibleSection<Row> {
    
    func prettyPrint() -> String {
        var text = ""
        for section in self {
            text += "--\(section.title)--\n"
            
            for row in section.rows {
                text += "\(row.title)\n"
            }
            
            text += "\n"
        }
        return text
    }
}
