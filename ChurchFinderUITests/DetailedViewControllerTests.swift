//
//  DetailedViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 3/1/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest

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
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        // Failed to find matching element please file bug (bugreport.apple.com) and provide output from Console.app
        
        let app = XCUIApplication()
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let button = element.childrenMatchingType(.Button).matchingIdentifier("Button").elementBoundByIndex(1)
        button.tap()
        button.tap()
        element.tap()
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIDevice.sharedDevice().orientation = .Portrait
        app.statusBars.buttons["Back to ChurchFinder"].tap()
        XCUIDevice.sharedDevice().orientation = .Portrait
        XCUIDevice.sharedDevice().orientation = .Portrait
        element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Map).element.tap()
        element.childrenMatchingType(.Button).matchingIdentifier("Button").elementBoundByIndex(0).tap()
        
    }
    
}
