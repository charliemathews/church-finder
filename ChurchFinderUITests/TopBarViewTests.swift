//
//  TopBarViewTests.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 4/10/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

class TopBarViewTests: XCTestCase {
    
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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testBookmarksNav() {
        XCUIApplication().tabBars.buttons["Bookmarks"].tap()
        waitForElementToAppear(XCUIApplication().navigationBars["Bookmarks"].staticTexts["Bookmarks"])
    }
    
    func testChurchesNav() {
        XCUIApplication().tabBars.buttons["Bookmarks"].tap()
        XCUIApplication().tabBars.buttons["Churches"].tap()
        XCTAssert(XCUIApplication().tabBars.buttons["Churches"].selected)
    }
    
    func testMapButton() {
        XCUIApplication().navigationBars.buttons["Map"].tap()
        XCTAssert(XCUIApplication().navigationBars.buttons["Map"].selected)
    }
    
    func testListButton() {
        XCUIApplication().navigationBars.buttons["Map"].tap()
        XCUIApplication().navigationBars.buttons["List"].tap()
        XCTAssert(XCUIApplication().navigationBars.buttons["List"].selected)
    }
    
    func testSearchBar() {
        let app = XCUIApplication()
        app.navigationBars.buttons["location icon 22"].tap()
        app.buttons["Cancel"].tap()
    }
    
    func testFilterButton() {
        sleep(15)
        let app = XCUIApplication()
        app.navigationBars.buttons["Filters"].tap()
        waitForElementToAppear(app.navigationBars["Filters"].staticTexts["Filters"])
        
    }
    
}
