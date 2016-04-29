//
//  BookmarksViewTests.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 3/7/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

class BookmarksViewTests: XCTestCase {
    
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
        XCUIApplication().tabBars.buttons["Bookmarks"].tap()
        //Tests assume that there exists at least one bookmark
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDetailedViewButton() {
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].tap()
        waitForElementToAppear(XCUIApplication().staticTexts["SHARE"])
    }
    
    func testDeleteButtonSwipe() {
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].swipeLeft()
        
        waitForElementToAppear(XCUIApplication().tables.cells.allElementsBoundByIndex[0].buttons["Delete"])
    }
    
    func testDeleteButton() {
        let delete = XCUIApplication().tables.cells.allElementsBoundByIndex[0]
        delete.swipeLeft()
        XCUIApplication().tables.buttons["Delete"].tap()
    }
    
    func testEditButton() {
        XCUIApplication().navigationBars["Bookmarks"].buttons["Edit"].tap()
        waitForElementToAppear(XCUIApplication().navigationBars["Bookmarks"].buttons["Done"])
        XCUIApplication().navigationBars["Bookmarks"].buttons["Done"].tap()
        waitForElementToAppear(XCUIApplication().navigationBars["Bookmarks"].buttons["Edit"])
    }
}
