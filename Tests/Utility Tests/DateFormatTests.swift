//
//  DateFormatTests.swift
//
//  Copyright © 2022 Johnson & Johnson
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

class DateFormatTests: XCTestCase {

    let testDate = Calendar.current.date(from: DateComponents(year: 1995, month: 1, day: 1, hour: 1, minute: 25, second: 0))!
    
    func testSharedFormatter() throws {
        DateFormat.shared.formatter.locale = .init(identifier: "en_US")
        DateFormat.shared.setStyle(time: .medium, date: .medium)
        XCTAssertEqual("Jan 1, 1995 at 1:25:00 AM", DateFormat.shared.formatter.string(from: testDate))
    }
    
    func testFormatWithTemplate() throws {
        XCTAssertEqual(DateFormat.format(testDate, with: "YYYY-MM-DD"), "1995-01-01")
    }
}
