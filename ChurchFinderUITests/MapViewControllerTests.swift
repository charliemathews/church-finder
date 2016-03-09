//
//  MapViewControllerTests.swift
//  ChurchFinder
//
//  Created by Michael Curtis on 3/8/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

class MapViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
       
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testSearch() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.navigationBars.buttons["Map"].tap()
        let navigationBarsQuery = app.navigationBars
        navigationBarsQuery.buttons["Search"].tap()
        app.buttons["Cancel"].tap()
        navigationBarsQuery.buttons["Filters"].tap()
        tablesQuery.buttons["Done"].tap()
        app.otherElements["Current Location"].tap()
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
