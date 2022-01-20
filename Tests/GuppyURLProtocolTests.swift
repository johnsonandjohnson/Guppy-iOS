//
//  GuppyURLProtocolTests.swift
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

class GuppyURLProtocolTests: XCTestCase {
    
    var jsonURL: URL {
        let bundle = Bundle.module
        return bundle.url(forResource: "AtomicElements", withExtension: "json")!
    }
    
    override func setUp() {
        super.setUp()

        Guppy.registerURLProtocol()
        Guppy.shared.removeAllLogs()
    }
    
    override func tearDown() {
        super.tearDown()

        Guppy.shared.removeAllLogs()
    }
    
    func testNetworkRequest() {
        XCTAssertTrue(Guppy.shared.getAllLogs().isEmpty)

        let e = expectation(description: "myExpectation")
        
        URLSession.shared.dataTask(with: jsonURL) { _, _, error in
            // GuppyURLProtocol does not have a way to intercept data before calling completion on a dataTask.
            // Need to add a small delay here to help race condition between writing the new data to Guppy and reading it.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if let error = error {
                    XCTFail(error.localizedDescription)
                } else {
                    XCTAssertEqual(Guppy.shared.getAllLogs().count, 1)
                }
                
                e.fulfill()
            }
        }.resume()

        waitForExpectations(timeout: 10)
    }
}
