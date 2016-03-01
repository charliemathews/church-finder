//
//  FilterTableViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 2/27/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

class FilterTableViewControllerTests: XCTestCase {
        
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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let viewMapButton = app.tabBars.buttons["View Map"]
        viewMapButton.tap()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Map).element.tap()
        viewMapButton.tap()
        app.navigationBars.buttons["Filters"].tap()
        
        let tablesQuery2 = app.tables
        let tablesQuery = tablesQuery2
        tablesQuery.staticTexts["Denomination"].tap()
        tablesQuery.staticTexts["Worship Style"].tap()
        tablesQuery.staticTexts["Size"].tap()
        tablesQuery.staticTexts["Times"].tap()
        
        let evangelicalPickerWheel = tablesQuery.pickerWheels["Evangelical"]
        evangelicalPickerWheel.tap()
        
        let contemporaryPickerWheel = tablesQuery.pickerWheels["Contemporary"]
        contemporaryPickerWheel.tap()
        
        let pickerWheel = tablesQuery.pickerWheels["0-100"]
        pickerWheel.tap()
        
        let pickerWheel2 = tablesQuery.pickerWheels["10:00-11:00"]
        pickerWheel2.tap()
        evangelicalPickerWheel.tap()
        contemporaryPickerWheel.tap()
        pickerWheel.tap()
        pickerWheel2.tap()
        tablesQuery2.buttons["Done"].tap()
        
    }
    
}