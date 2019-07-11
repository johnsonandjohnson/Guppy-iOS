//
//  SessionLogItemTableViewCell.swift
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

class SessionLogItemTableViewCell: UITableViewCell, NibLoadableView {

    @IBOutlet private var typeLabel: UILabel!
    @IBOutlet private var timelabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var domainLabel: UILabel!
    
    func setUp(_ logItem: LogItem & Session) {
        typeLabel.text = logItem.request.httpMethod ?? "Unknown"
        timelabel.text = DateFormat.shared.formatter.string(from: logItem.date)
        
        let pathURL = URLComponents(string: logItem.domain)?.path ?? logItem.domain
        domainLabel.text = pathURL

        if let statusCode = (logItem.response as? HTTPURLResponse)?.statusCode {
            statusLabel.textColor = StatusCode.color(for: statusCode)
            statusLabel.text = "\(statusCode) \(StatusCode.description(for: statusCode))"
        } else {
            statusLabel.textColor = .black
            statusLabel.text = "Unknown"
        }
    }
}
