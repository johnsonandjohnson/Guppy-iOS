//
//  StatusCodeTests.swift
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

class StatusCodeTests: XCTestCase {

    func testDescription() {
        XCTAssertEqual(StatusCode.description(for: 0), "Unknown")
        XCTAssertEqual(StatusCode.description(for: 200), "OK")
        XCTAssertEqual(StatusCode.description(for: 500), "Internal Server Error")
        XCTAssertEqual(StatusCode.description(for: 511), "Network Authentication Required")
    }

    func testColor() {
        XCTAssertEqual(StatusCode.color(for: 200), Colors.Status.darkGreen)
        XCTAssertEqual(StatusCode.color(for: 299), Colors.Status.darkGreen)

        XCTAssertEqual(StatusCode.color(for: 100), .red)
        XCTAssertEqual(StatusCode.color(for: 300), .red)
        XCTAssertEqual(StatusCode.color(for: 400), .red)
        XCTAssertEqual(StatusCode.color(for: 500), .red)

    }
}
