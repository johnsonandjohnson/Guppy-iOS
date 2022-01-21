//
//  GuppyTests.swift
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

class GuppyTests: XCTestCase {

    override func setUp() {
        super.setUp()

        Guppy.shared.removeAllLogs()
    }

    override func tearDown() {
        super.tearDown()

        Guppy.shared.removeAllLogs()
    }

    func testGuppyURLProtocol() {
        let configWithoutGuppy = URLSessionConfiguration.default
        let noGuppySession = URLSession(configuration: configWithoutGuppy)

        if let protocolClasses = noGuppySession.configuration.protocolClasses {
            XCTAssertFalse(protocolClasses.contains { $0 is GuppyURLProtocol.Type })
        } else {
            XCTFail("Unable to find protocol classes")
        }

        let configWithGuppy = URLSessionConfiguration.default
        configWithGuppy.protocolClasses = [GuppyURLProtocol.self]

        let gupppySession = URLSession(configuration: configWithGuppy)
        if let protocolClasses = gupppySession.configuration.protocolClasses {
            XCTAssertTrue(protocolClasses.contains { $0 is GuppyURLProtocol.Type })
        } else {
            XCTFail("Unable to find protocol classes")
        }
    }

    func testLogging() {
        XCTAssertTrue(Guppy.shared.getAllLogs().isEmpty)

        let logItem = NetworkData(id: UUID(),
                                  domain: "google.com",
                                  date: Date(),
                                  request: URLRequest(url: URL(string: "https://google.com")!),
                                  response: nil,
                                  responseData: nil,
                                  requestData: nil,
                                  isRequestComplete: true)
        Guppy.shared.log(logItem)

        XCTAssertEqual(Guppy.shared.getAllLogs().count, 1)
    }

    func testRemoveAllLogs() {
        let logItem = NetworkData(id: UUID(),
                                  domain: "google.com",
                                  date: Date(),
                                  request: URLRequest(url: URL(string: "https://google.com")!),
                                  response: nil,
                                  responseData: nil,
                                  requestData: nil,
                                  isRequestComplete: true)
        Guppy.shared.log(logItem)
        XCTAssertEqual(Guppy.shared.getAllLogs().count, 1)

        Guppy.shared.removeAllLogs()
        XCTAssertTrue(Guppy.shared.getAllLogs().isEmpty)
    }
}
