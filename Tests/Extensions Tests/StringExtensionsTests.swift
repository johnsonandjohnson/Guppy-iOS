//
//  StringExtensionsTests.swift
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

class StringExtensionsTests: XCTestCase {

    private let font = UIFont.preferredFont(forTextStyle: .body)

    func testHighlight() {
        let startString = "This is a "
        let middleString = "sample"
        let endString = " string"

        let sampleString = startString + middleString + endString
        let attributedString = sampleString.highlight(searchText: "sample")

        var startStringRange = NSRange(location: 0, length: startString.count)
        let startStringAttributes = attributedString.attributes(at: 0, effectiveRange: &startStringRange)

        XCTAssertEqual(startStringAttributes.count, 2)
        if let attribute = startStringAttributes.first(where: { $0.key == .font }) {
            XCTAssertEqual(attribute.key, .font)
            XCTAssertEqual(attribute.value as? UIFont, font)
        } else {
            XCTFail("Missing font attribute")
        }
        
        if let attribute = startStringAttributes.first(where: { $0.key == .foregroundColor }) {
            XCTAssertEqual(attribute.key, .foregroundColor)
            XCTAssertEqual(attribute.value as? UIColor, .label)
        } else {
            XCTFail("Missing foreground attribute")
        }
        
        var middleStringRange = NSRange(location: 0, length: middleString.count)
        let middleStringAttributes = attributedString.attributes(at: startString.count, effectiveRange: &middleStringRange)

        XCTAssertEqual(middleStringAttributes.count, 3)
        if let attribute = middleStringAttributes.first(where: { $0.key == .font }) {
            XCTAssertEqual(attribute.key, .font)
            XCTAssertEqual(attribute.value as? UIFont, font)
        } else {
            XCTFail("Missing font attribute")
        }
        if let attribute = middleStringAttributes.first(where: { $0.key == .backgroundColor }) {
            XCTAssertEqual(attribute.key, .backgroundColor)
            XCTAssertEqual(attribute.value as? UIColor, .systemGray)
        } else {
            XCTFail("Missing backgroundColor attribute")
        }
        
        if let attribute = middleStringAttributes.first(where: { $0.key == .foregroundColor }) {
            XCTAssertEqual(attribute.key, .foregroundColor)
            XCTAssertEqual(attribute.value as? UIColor, .label)
        } else {
            XCTFail("Missing foreground attribute")
        }

        var endStringRange = NSRange(location: 0, length: endString.count)
        let endStringAttributes = attributedString.attributes(at: startString.count + middleString.count, effectiveRange: &endStringRange)

        XCTAssertEqual(endStringAttributes.count, 2)
        if let attribute = endStringAttributes.first(where: { $0.key == .font }) {
            XCTAssertEqual(attribute.key, .font)
            XCTAssertEqual(attribute.value as? UIFont, font)
        } else {
            XCTFail("Missing font attribute")
        }
        
        if let attribute = endStringAttributes.first(where: { $0.key == .foregroundColor }) {
            XCTAssertEqual(attribute.key, .foregroundColor)
            XCTAssertEqual(attribute.value as? UIColor, .label)
        } else {
            XCTFail("Missing foreground attribute")
        }
    }

    func testMatches() {
        let sampleString = "this is a sample string"
        XCTAssertTrue(sampleString.matches("sample"))
        XCTAssertFalse(sampleString.matches("failure"))
    }

    func testRemoveBackslashes() {
        let sampleJsonString = "[\n  {\n    \"id\" : 1,\n    \"organizations_url\" : \"https:\\/\\/api.github.com\\/users\\/mojombo\\/orgs\",\n    \n }\n]"
        let expectedJsonString = "[\n  {\n    \"id\" : 1,\n    \"organizations_url\" : \"https://api.github.com/users/mojombo/orgs\",\n    \n }\n]"

        let jsonStringWithoutBackslashes = sampleJsonString.removeBackslashes()
        XCTAssertEqual(jsonStringWithoutBackslashes, expectedJsonString)
    }

    func testEscapeQuotes() {
        let sampleString = "“testing”"
        let expectedString = "[\"|”]testing[\"|”]"

        let jsonStringWithEscapedQuotes = sampleString.escapeQuotes()
        XCTAssertEqual(jsonStringWithEscapedQuotes, expectedString)
    }
}
