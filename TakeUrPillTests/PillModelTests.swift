//
//  PillModelTests.swift
//  TakeUrPillTests
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import XCTest
@testable import TakeUrPill

class PillModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPillInit() {
        let stubDate = Date().timeIntervalSince1970
        let sut = Pill(timestamp: stubDate,
                        amount: 0,
                        name: "test")

        XCTAssertNotNil(sut)

        XCTAssertEqual(sut.name, "test")
        XCTAssertEqual(sut.amount, 0)
        XCTAssertEqual(sut.timestamp, stubDate)
    }
}
