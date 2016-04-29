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
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
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
    
    func testCurrentLocation() {
        let app = XCUIApplication()
        app.navigationBars.buttons["location icon 22"].tap()
        app.buttons["Use current location"].tap()
    }
    
    func testNewLocation() {
        let app = XCUIApplication()
        app.navigationBars.buttons["location icon 22"].tap()
        app.buttons["Search for new location"].tap()
        app.buttons["Cancel"].tap()
    }
    
    // Test fails if the app doesn't load in time, adjust sleep or try again.
    func testFilterButton() {
        sleep(15)
        let app = XCUIApplication()
        app.navigationBars.buttons["Filters"].tap()
        waitForElementToAppear(app.navigationBars["Filters"].staticTexts["Filters"])
        
    }
    
}
