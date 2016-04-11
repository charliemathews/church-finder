
//
//  MapViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 3/8/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import XCTest



class MapViewControllerTests: XCTestCase {
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
    
    func testMapPins() {
        XCUIApplication().childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).matchingIdentifier("Grace United Methodist Church, SUN 10:00, SAT 18:00").elementBoundByIndex(0).tap()
    }
    
    func testMapPinDisclosure() {
        
    }
    
    func testSearchBarSearchButtonClicked_CaseNothingFound() {
        
        let app = XCUIApplication()
        app.tables.navigationBars.buttons["Map"].tap()
        app.navigationBars.buttons["Search"].tap()
        app.searchFields["Search"].typeText("oiwjefowi")
        app.typeText("jefwoiejf\r")
        
        waitForElementToAppear(app.alerts.collectionViews.buttons["Dismiss"])
        app.alerts.collectionViews.buttons["Dismiss"].tap()
    }
    
    func testSearchBarSearchButtonClicked_PlaceFound() {
        XCUIDevice.sharedDevice().orientation = .Portrait
        
        let app = XCUIApplication()
        app.tables.navigationBars.buttons["Map"].tap()
        app.navigationBars.buttons["Search"].tap()
        app.searchFields["Search"].typeText("grove city")
        app.typeText("\r")
        waitForElementToAppear(app.otherElements["Map pin"])
        app.otherElements["Map pin"].tap()
    }
    
}
