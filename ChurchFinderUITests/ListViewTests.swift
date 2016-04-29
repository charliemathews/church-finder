//
//  ListViewTests.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 3/7/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

class ListViewTests: XCTestCase {
    
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
        // All tests fail if the app doesn't load in time, adjust sleep or try again.
        sleep(20)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDetailedViewButton() {
        waitForElementToAppear(XCUIApplication().tables.cells.allElementsBoundByIndex[0])
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].tap()
        waitForElementToAppear(XCUIApplication().staticTexts["SHARE"])
    }
    
    func testSwipeBookmarksButton() {
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].swipeLeft()
        waitForElementToAppear(XCUIApplication().tables.buttons["Save"])
    }
    
    func testBookmarksButton() {
        let book = XCUIApplication().tables.cells.allElementsBoundByIndex[0]
        
        book.swipeLeft()
        XCUIApplication().tables.buttons["Save"].tap()
        book.swipeLeft()
        XCUIApplication().tables.buttons["Unsave"].tap()
    }
    
}
