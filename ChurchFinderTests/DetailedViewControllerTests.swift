//
//  DetailedViewControllerTests.swift
//  ChurchFinder
//
//  Created by Sam Gill on 3/6/16.
//  Copyright © 2016 Michael Curtis. All rights reserved.
//

import UIKit
import XCTest
import MapKit
@testable import ChurchFinder

class DetailedViewControllerTests: XCTestCase {
    
    var viewController: DetailedViewController!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DetailedViewController") as! DetailedViewController
        
        //this is a depricated function, don't use
        //viewController.church = GrabChurchList(0, n: 1).first!
        
        viewController.loadView()
        //viewController.viewDidLoad()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
    }
    
    
    func testNil() {
        XCTAssertNotNil(viewController.directionsImage)
        XCTAssertNotNil(viewController.directionsLabel)
        XCTAssertNotNil(viewController.churchViewImage)
        XCTAssertNotNil(viewController.bookMarkIcon)
        XCTAssertNotNil(viewController.shareImage)
        XCTAssertNotNil(viewController.shareLabel)
        XCTAssertNotNil(viewController.distanceLabel)
        XCTAssertNotNil(viewController.namesLabel)
        XCTAssertNotNil(viewController.denominationLabel)
        XCTAssertNotNil(viewController.churchMap)
        XCTAssertNotNil(viewController.worshipStyleLabel)
        XCTAssertNotNil(viewController.timeLabel)
        XCTAssertNotNil(viewController.addressLabel)
        XCTAssertNotNil(viewController.descriptionLabel)
        XCTAssertNotNil(viewController.websiteLinkLabel)
        XCTAssertNotNil(viewController.websiteIcon)
    }
    
    
    func testViewDidLoad() {
        
        XCTAssertNotNil(viewController.viewDidLoad())
    }
    
    func testToggleBookMark() {
        
        let bookmarkOriginalValue = viewController.bookmarked
        
        viewController.toggleBookMark()
        //check to see if bool value changed
        XCTAssert(bookmarkOriginalValue != viewController.bookmarked)
        
        //check to see if its the right image
        if viewController.bookmarked {
            XCTAssert( viewController.bookMarkIcon.imageView?.image == UIImage(named: "star-512.png")!)
        } else {
            XCTAssert( viewController.bookMarkIcon.imageView?.image == UIImage(named: "star-xxl.png")!)
        }
    }
    
    func testOpenChurchWebsiteFail() {
        //testing if the UIAlertController is popped up
        viewController.church.url = "junkUrl"
        
        //the presented view controller should just be the view controller
        print(viewController.isBeingPresented())
        XCTAssertNotNil(viewController.openChurchWebsite())
        
    }
    
    func testOpenChurchWebsiteSuccess() {
        
        //viewController.church.url = "https://www.facebook.com"
        
        //the presented view controller should just be the view controller
        //XCTAssertEqual(viewController.presentedViewController, viewController)
        
        XCTAssertNotNil(viewController.openChurchWebsite())
        
        //now it should be the alert view controller
        //XCTAssertEqual(viewController.presentedViewController, viewController)
    }
    
    func testShareButtonPopup() {
        XCTAssertNotNil(viewController.share())
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
