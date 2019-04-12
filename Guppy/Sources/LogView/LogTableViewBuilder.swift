//
//  LogTableViewBuilder.swift
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

class LogTableViewBuilder {
    
    static func getDomainSections(from logItems: [LogItem], in domainSections: [CollapsibleSection<LogItem>] = []) -> [CollapsibleSection<LogItem>] {
        let sortedLogItems = logItems.sorted { $0.date > $1.date }
        
        var domainSectionMap: [String: [LogItem]] = [:]
        
        for logItem in sortedLogItems {
            let domainString = URL(string: logItem.domain)?.host ?? logItem.domain
            
            if domainSectionMap[domainString] != nil {
                domainSectionMap[domainString]?.append(logItem)
            } else {
                domainSectionMap[domainString] = [logItem]
            }
        }
        
        let updatedDomainSections = domainSectionMap.map { (title, itemArray) -> CollapsibleSection<LogItem> in
            if let sectionIndex = domainSections.firstIndex(where: { $0.title == title }) {
                return CollapsibleSection(title: title, rows: itemArray, isCollapsed: domainSections[sectionIndex].isCollapsed)
            } else {
                return CollapsibleSection(title: title, rows: itemArray, isCollapsed: true)
            }
        }
        
        return updatedDomainSections
    }
    
    static func getSections(from session: Session) -> [CollapsibleSection<Row>] {
        var sections: [CollapsibleSection<Row>] = []
        
        // Overview
        var overviewRows: [Row] = []
        let hostURL = "\(session.request.httpMethod ?? "Unknown") \(session.request.url?.absoluteString ?? "Unknown")"
        let row = Row(title: hostURL)
        
        overviewRows.append(row)
    
        let statusCode = "Status Code: \((session.response as? HTTPURLResponse)?.statusCode.description ?? "Unknown")"
        let statusRow = Row(title: statusCode)
        overviewRows.append(statusRow)
        
        let overviewSection = CollapsibleSection(title: "Overview", rows: overviewRows, isCollapsed: false)
        sections.append(overviewSection)
        
        // Request Header
        if let headerFields = session.request.allHTTPHeaderFields {
            let row = Row(title: "\(headerFields)".removeBackslashes())
            
            let responseHeaderSection = CollapsibleSection(title: "Request Header", rows: [row], isCollapsed: false)
            sections.append(responseHeaderSection)
        }
        
        // Request Json
        if let data = session.requestData,
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .ascii) {
            
            let row = Row(title: "\(jsonString.removeBackslashes())")
            
            let requestJSONSection = CollapsibleSection(title: "Request JSON", rows: [row], isCollapsed: false)
            sections.append(requestJSONSection)
        }
        
        // Response Header
        if let httpResponse = session.response as? HTTPURLResponse, let headerFields = httpResponse.allHeaderFields as? Dictionary<String, String>{
            
            let row = Row(title: "\(headerFields)".removeBackslashes())
            
            let requestHeaderSection = CollapsibleSection(title: "Response Header", rows: [row], isCollapsed: false)
            sections.append(requestHeaderSection)
        }
        
        // Response JSON
        if let data = session.responseData,
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDictionary, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .ascii) {
           
            let row = Row(title: "\(jsonString.removeBackslashes())")
            
            let responseJSONSection = CollapsibleSection(title: "Response JSON", rows: [row], isCollapsed: false)
            sections.append(responseJSONSection)
        }
        
        return sections
    }
}
