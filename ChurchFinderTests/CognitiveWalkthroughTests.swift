/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 06/03/16
Modified: 08/03/16
*/

import XCTest
@testable import ChurchFinder

class CognitiveWalkthroughTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func findChurchesInTheArea() { // default, no location input
        let app = XCUIApplication()
    }
    
    func findChurchesInAnAreaUsingCustomLocation() { // zip or address input
        //
    }
    
    func findChurchesInAnAreaUsingCurrentLocation() { // current location button selected
        //
    }
    
    
}
