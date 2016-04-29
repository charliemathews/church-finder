//
//  DetailedViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 3/1/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest
@testable import ChurchFinder


class DetailedViewControllerTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        // All tests fail if the app doesn't load in time, adjust sleep or try again.
        sleep(15)
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].tap()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    func testSafariOpen() {
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
    }
    
    func testPressBookmarksIcon() {
        let button = XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Button).matchingIdentifier("Button").elementBoundByIndex(1)
        button.tap()
        button.tap()
    }
    
    func testDirectionsButton() {
        let app = XCUIApplication()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
    }
    
    func testShareButton() {
        let app = XCUIApplication()
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
    }
}
