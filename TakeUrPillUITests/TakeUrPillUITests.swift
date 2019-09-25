//
//  TakeUrPillUITests.swift
//  TakeUrPillUITests
//
//  Created by Alessio Roberto on 13/10/2018.
//  Copyright © 2018 Alessio Roberto. All rights reserved.
//

import XCTest

class TakeUrPillUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testAddPill() {
        let app = XCUIApplication()
        app.buttons["add pill"].tap()
        app.textFields["insert name"].tap()
        
        let aKey = app/*@START_MENU_TOKEN@*/.keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()
        
        let sKey = app/*@START_MENU_TOKEN@*/.keys["s"]/*[[".keyboards.keys[\"s\"]",".keys[\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        sKey.tap()
        
        let pKey = app/*@START_MENU_TOKEN@*/.keys["p"]/*[[".keyboards.keys[\"p\"]",".keys[\"p\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        pKey.tap()
        
        let iKey = app/*@START_MENU_TOKEN@*/.keys["i"]/*[[".keyboards.keys[\"i\"]",".keys[\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        iKey.tap()
        
        let rKey = app.keys["r"]
        rKey.tap()
        
        iKey.tap()
        
        let nKey = app.keys["n"]
        nKey.tap()
        
        aKey.tap()
        
        app.textFields["insert amount"].tap()
        
        let key = app/*@START_MENU_TOKEN@*/.keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        snapshot("0AddPill")
        app.buttons["save"].tap()
    }
    
    func testTookPill() {
        
        let app = XCUIApplication()
        app.buttons["took my pill"].tap()
        snapshot("1TookMyPill")
        app.buttons["done"].tap()
        snapshot("2TookMyPillDone")
    }

    func testHistory() {
        XCUIApplication().buttons["history"].tap()
        snapshot("3History")
    }
}
