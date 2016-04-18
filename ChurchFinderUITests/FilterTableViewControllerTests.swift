//
//  FilterTableViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 2/27/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest
@testable import ChurchFinder

class FilterTableViewControllerTests: XCTestCase {
    
    //http://masilotti.com/xctest-helpers/
    private func waitForElementToAppear(element: XCUIElement, file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectationForPredicate(existsPredicate,
                                evaluatedWithObject: element, handler: nil)
        
        waitForExpectationsWithTimeout(5) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after 5 seconds."
                self.recordFailureWithDescription(message,
                                                  inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().navigationBars.buttons["Filters"].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCong() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["Congregation Size"].tap()
        tablesQuery.staticTexts["100"].tap()
        waitForElementToAppear(tablesQuery.staticTexts["100"])
    }
    
    func testDom() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["Denomination"].tap()
        tablesQuery.staticTexts["Non-Denominational"].tap()
        waitForElementToAppear(tablesQuery.staticTexts["Non-Denominational"])
    }
    
    func testWors() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.staticTexts["Worship Style"].tap()
        tablesQuery.staticTexts["Traditional/Contemporary"].tap()
        waitForElementToAppear(tablesQuery.staticTexts["Traditional/Contemporary"])
    }
    
    func testClear() {
        XCUIApplication().navigationBars["Filters"].buttons["Clear"].tap()
    }
    
    func testDone() {
        XCUIApplication().navigationBars["Filters"].buttons["Done"].tap()        
    }
    
}
