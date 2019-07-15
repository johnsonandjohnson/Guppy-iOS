//
//  LogTableViewBuilderTests.swift
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

import XCTest
@testable import Guppy

class LogTableViewBuilderTests: XCTestCase {

    func testGetDomainSections() {
        let domain = "google.com"
        let logItem1 = NetworkData(domain: domain, date: Date(), request: URLRequest(url: URL(string: "https://google.com")!), response: nil, responseData: nil, requestData: nil)
        let logItem2 = NetworkData(domain: domain, date: Date(), request: URLRequest(url: URL(string: "https://google.com")!), response: nil, responseData: nil, requestData: nil)

        let domainSections = LogTableViewBuilder.getDomainSections(from: [logItem1, logItem2])

        XCTAssertEqual(domainSections.count, 1)

        guard let section = domainSections.first else {
            XCTFail("Unable to get domainSection")
            return
        }

        XCTAssertTrue(section.isCollapsed)
        XCTAssertEqual(section.title, domain)

        if let logItem = section.rows.first(where: { $0.date == logItem1.date }) {
            XCTAssertEqual(logItem.domain, domain)
            XCTAssertEqual(logItem.details, logItem1.details)
        } else {
            XCTFail("Unable to find logItem1")
        }

        if let logItem = section.rows.first(where: { $0.date == logItem2.date }) {
            XCTAssertEqual(logItem.domain, domain)
            XCTAssertEqual(logItem.details, logItem2.details)
        } else {
            XCTFail("Unable to find logItem1")
        }
    }

    func testGetSections() {
        let domain = "google.com"
        let urlString = "https://google.com"
        let logItem = NetworkData(domain: domain, date: Date(), request: URLRequest(url: URL(string: "https://google.com")!), response: nil, responseData: nil, requestData: nil)
        let sections = LogTableViewBuilder.getSections(from: logItem)

        XCTAssertEqual(sections.count, 1)

        if let section = sections.first {
            XCTAssertFalse(section.isCollapsed)
            XCTAssertEqual(section.title, "Overview")
            XCTAssertEqual(section.rows.count, 2)
            XCTAssertEqual(section.rows[0].title, "GET \(urlString)")
            XCTAssertEqual(section.rows[1].title, "Status Code: Unknown")
        } else {
            XCTFail("Unable to find first section")
        }
    }
}
