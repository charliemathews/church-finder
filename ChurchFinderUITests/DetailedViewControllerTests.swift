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
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        sleep(15)
        XCUIApplication().tables.cells.allElementsBoundByIndex[0].tap()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
