//
//  AirDropTextDataSourceTests.swift
//
//
//  Created by Brandon Walton on 1/26/22.
//

import XCTest
@testable import Guppy

class AirDropTextDataSourceTests: XCTestCase {

    let activityViewController = UIActivityViewController(activityItems: [], applicationActivities: nil)
    let datasource = AirDropTextDataSource(with: "ShareText")
    
    func testExample() throws {
        XCTAssertEqual(datasource.activityViewControllerPlaceholderItem(activityViewController) as! String, NSTemporaryDirectory())
    }
    
    func testItemForActivityType() {
        XCTAssertTrue(datasource.activityViewController(activityViewController, itemForActivityType: .airDrop) is URL)
    }
}
