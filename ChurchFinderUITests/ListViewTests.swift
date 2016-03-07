//
//  ListViewTests.swift
//  ChurchFinder
//
//  Created by Daniel Mitchell on 3/7/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

class ListViewTests: XCTestCase {
        
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
    
    func testBookmarksButton() {
        
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Bookmarks"].tap()
    }
    
    func testFiltersButton() {
        XCUIApplication().tables.navigationBars.buttons["Filters"].tap()
        
    }
    
    func testMapButton() {
        XCUIApplication().tables.navigationBars.buttons["Map"].tap()
        
    }
    
    func testDetailedViewButton() {
        XCUIApplication().tables.staticTexts["SUN 11:00"].tap()
    }
    
    func testAddBookmarksButton() {
        let tablesQuery = XCUIApplication().tables
        tablesQuery.cells.containingType(.StaticText, identifier:"East Main Presbyterian Church").staticTexts["Traditional"].swipeLeft()
        tablesQuery.buttons["Bookmark"].tap()
    }
    
}
