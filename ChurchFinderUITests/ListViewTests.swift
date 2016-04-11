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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDetailedViewButton() {
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].tap()
        waitForElementToAppear(XCUIApplication().staticTexts["SHARE"])
    }
    
    func testSwipeBookmarksButton() {
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].swipeLeft()
        waitForElementToAppear(XCUIApplication().tables.cells.allElementsBoundByIndex[0].buttons["Bookmark"])
    }
    
    func testBookmarksButton() {
        let book = XCUIApplication().tables.cells.allElementsBoundByIndex[0]
        
        book.swipeLeft()
        book.buttons["Bookmark"].tap()
    }
    
}
