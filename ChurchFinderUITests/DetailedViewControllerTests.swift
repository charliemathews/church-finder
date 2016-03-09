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
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testSafariOpen() {
        
        let app = XCUIApplication()
        app.tables.staticTexts["Evangelical"].tap()
        
        //tapping web image icon
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.tap()
        
    }

    
    
    ///This test is useless for now
//    func testFailSafariOpen() {
//        XCUIDevice.sharedDevice().orientation = .Portrait
//        
//        let app = XCUIApplication()
//        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(3).staticTexts["Needs work"].tap()
//        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
//        
//        
//        app.alerts["Error"].collectionViews["OK"].tap()
//    }
    
    func testPressBookmarksIcon() {
        let app = XCUIApplication()
        app.tables.staticTexts["SUN 10:30"].tap()
        
        let button = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Button).matchingIdentifier("Button").elementBoundByIndex(1)

        button.tap()
        //shouldn't be the same
        button.tap()
        //should be the same now
    }
    
    func testDirectionsButton() {
        
        let app = XCUIApplication()
        app.tables.staticTexts["Evangelical"].tap()
        app.staticTexts["DIRECTIONS"].tap()
        
        //can't test because other application opens....
        
    }
    
    func testShareButton() {
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = XCUIApplication()
        app.tables.staticTexts["Presbyterian"].tap()
        app.staticTexts["SHARE"].tap()
        app.sheets.buttons["Cancel"].tap()
        
    }
}
