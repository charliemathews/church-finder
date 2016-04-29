
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
        continueAfterFailure = false
        XCUIApplication().launch()
        XCUIApplication().navigationBars.buttons["Map"].tap()
        // All tests fail if the app doesn't load in time, adjust sleep or try again.
        // Tests in this file are LOCATION DEPENDANT, will only work in Grove City area
        sleep(20)
    }
    
    override func tearDown() {
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
