//
//  CollapsibleSectionTests.swift
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

class CollapsibleSectionTests: XCTestCase {

    func testPrettyPrint() {
        let section1 = CollapsibleSection(title: "Test1", rows: [Row(title: "Title1")], isCollapsed: false)

        let printedSection1 = [section1].prettyPrint()
        let expectedSection1 = "--Test1--\nTitle1\n\n"

        XCTAssertEqual(printedSection1, expectedSection1)

        let section2 = CollapsibleSection(title: "Test2", rows: [Row(title: "Title1"), Row(title: "Title2")], isCollapsed: false)

        let printedSections = [section1, section2].prettyPrint()
        let expectedSections = "--Test1--\nTitle1\n\n--Test2--\nTitle1\nTitle2\n\n"

        XCTAssertEqual(printedSections, expectedSections)

    }
}
