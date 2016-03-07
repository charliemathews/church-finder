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
        
        viewController.church = GrabChurchList(0, n: 1).first!
        
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
        
        viewController.viewDidLoad()
    }
    
    func testCenterMap() {
        
        //        func centerMapOnLocation(location: CLLocation) {
        //            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
        //                regionRadius * 2.0, regionRadius * 2.0)
        //            churchMap.setRegion(coordinateRegion, animated: true)
        //        }
        //var sampleLocation: CLLocation = CLLocation(
        
        //let coordinates = CLLocationCoordinate2D(latitude: 2.0, longitude: 2.0)
        
        //        viewController.centerMapOnLocation(CLLocation(latitude: 2.0, longitude: 2.0))
        //        XCTAssert(viewController.churchMap.region == MKCoordinateRegionMakeWithDistance(coordinates, viewController.regionRadius * 2.0, viewController.regionRadius * 2.0))
        
        
    }
    
    func testToggleBookMark() {
        //        @IBAction func toggleBookMark() {
        //            if bookmarked {
        //                bookMarkIcon.setImage(UIImage(named: "star-xxl.png"), forState: .Normal)
        //            }
        //            else {
        //                bookMarkIcon.setImage(UIImage(named: "star-512.png"), forState: .Normal)
        //            }
        //
        //            bookmarked = !bookmarked
        //        }
        
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
    
    func testOpenChurchWebsite() {
//        func openChurchWebsite() {
//            if let url = NSURL(string: church.url) {
//                
//                if UIApplication.sharedApplication().canOpenURL(url) == false {
//                    let alertController = UIAlertController(title: "Error", message: "This website doesn't exist", preferredStyle: .Alert)
//                    
//                    let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                    alertController.addAction(defaultAction)
//                    
//                    presentViewController(alertController, animated: true, completion: nil)
//                }
//                
//                
//                UIApplication.sharedApplication().openURL(url)
//            }
//        }
//        print(viewController.church.url)
////        viewController.church.url = "https://www.facebook.com"
//        print(UIApplication.sharedApplication().windows.count)
//        print(UIApplication.sharedApplication().windows.description)
//
//        viewController.toggleBookMark()
//        print(UIApplication.sharedApplication().windows.count)
//        
//        print(UIApplication.sharedApplication().windows.description)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    
}
