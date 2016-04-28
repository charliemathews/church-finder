
//
//  MapViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 3/8/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest



class MapViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        XCUIApplication().navigationBars.buttons["Map"].tap()
        sleep(20)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapPins() {
        let app = XCUIApplication()
        app.otherElements["Fellowship Community Church, SUN 9:30a "].tap()
        
    }
    
    func testMapPinDisclosure() {
        
        let app = XCUIApplication()
        let fellowshipCommunityChurchSun930aElement = app.otherElements["Fellowship Community Church, SUN 9:30a "]
        fellowshipCommunityChurchSun930aElement.tap()
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Button).element.tap()
        element.childrenMatchingType(.Button).matchingIdentifier("Button").elementBoundByIndex(0).tap()
    }
}
