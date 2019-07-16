//
//  FileManagerExtensionsTests.swift
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

class FileManagerExtensionsTests: XCTestCase {

    override func setUp() {
        super.setUp()

        try? FileManager.default.removeItem(at: FileManager.guppyDir)
    }

    override func tearDown() {
        super.tearDown()

        try? FileManager.default.removeItem(at: FileManager.guppyDir)
    }

    func testCreateGuppyFolder() {
        XCTAssertFalse(FileManager.default.fileExists(atPath: FileManager.guppyDir.path))

        FileManager.default.createGuppyFolder()

        XCTAssertTrue(FileManager.default.fileExists(atPath: FileManager.guppyDir.path))
    }

    func testClearGuppyLog() {
        FileManager.default.createGuppyFolder()
        XCTAssertTrue(FileManager.default.fileExists(atPath: FileManager.guppyDir.path))

        FileManager.default.clearGuppyLog()
        try? FileManager.default.removeItem(at: FileManager.guppyDir)

        XCTAssertFalse(FileManager.default.fileExists(atPath: FileManager.guppyDir.path))
    }
}
