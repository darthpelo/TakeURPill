//
//  StorageTests.swift
//  TakeUrPillTests
//
//  Created by Alessio Roberto on 13/07/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import XCTest
@testable import TakeUrPill

class StorageTests: XCTestCase {
    let stubDate = Date().timeIntervalSince1970

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        let _ = deleteFiles()
    }

    func testPillEncode() {
        let stubDate = Date().timeIntervalSince1970
        let sut = Pill(timestamp: stubDate,
                       amount: 0,
                       name: "test")

        let encoder = JSONEncoder()
        let json = try! encoder.encode(sut)

        let decoder = JSONDecoder()
        let result = try! decoder.decode(Pill.self, from: json)

        XCTAssertEqual(result, sut)
    }

    func testPillsEncode() {
        let stubDate = Date().timeIntervalSince1970

        let pillOne = Pill(timestamp: stubDate,
                           amount: 1,
                           name: "one")

        let pillTwo = Pill(timestamp: stubDate,
                           amount: 1,
                           name: "two")

        let list = [pillOne, pillTwo]

        let encoder = JSONEncoder()
        let json = try! encoder.encode(list)

        let decoder = JSONDecoder()
        let result = try! decoder.decode([Pill].self, from: json)

        XCTAssertEqual(result[0], pillOne)
        XCTAssertEqual(result[1], pillTwo)
    }

    private func getPill() -> Pill {
        return Pill(timestamp: stubDate,
                       amount: 0,
                       name: "test")
    }

    private func getPills() -> [Pill] {
        let pillOne = Pill(timestamp: stubDate,
                           amount: 1,
                           name: "one")

        let pillTwo = Pill(timestamp: stubDate,
                           amount: 1,
                           name: "two")

        return [pillOne, pillTwo]
    }

    private func deleteFiles() -> Bool {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)

            for fileURL in fileURLs {
                try fileManager.removeItem(at: fileURL)
            }
            return true
        } catch {
            return false
        }
    }
}
