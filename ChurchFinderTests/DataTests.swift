/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 25/02/16
Modified: 25/02/16
*/

import XCTest
import Parse
//@testable import ChurchFinder

class DataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        Parse.setApplicationId("OTXY6dM8ChkriarqrX4SPi2e2Def9v1EM0VVNoOW", clientKey: "5I1Iky8vY7hheR7X9QAejEbXaw96UMFBYGzVr4h3")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /*
        Tests for singleton, Data.
    */
    
    func testSharedInstance() {
        let instance = Data.sharedInstance
        XCTAssertNotNil(instance, "")
    }
    
    /* pointless, since you can't initialize
    func testSharedInstance_Unique() {
        let instance1 = Data()
        let instance2 = Data.sharedInstance
        XCTAssertFalse(instance1 === instance2)
    }
    */
    
    func testSharedInstance_Twice() {
        let instance1 = Data.sharedInstance
        let instance2 = Data.sharedInstance
        XCTAssertTrue(instance1 === instance2)
    }
    
    func testSharedInstance_ThreadSafety() {
        var instance1 : Data!
        var instance2 : Data!
        
        let expectation1 = expectationWithDescription("Instance 1")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            instance1 = Data.sharedInstance
            expectation1.fulfill()
        }
        let expectation2 = expectationWithDescription("Instance 2")
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            instance2 = Data.sharedInstance
            expectation2.fulfill()
        }
        
        waitForExpectationsWithTimeout(1.0) { (_) in
            XCTAssertTrue(instance1 === instance2)
        }
    }
    
    /*
        Tests for Data::getMeta()
    */
    func testMetaValidKey() {
        let key = "denomination"
        
        let instance = Data.sharedInstance
        //let meta : [String] = instance.getMeta(key)
        
        XCTAssertTrue(instance.getMeta(key).count > 0)
    }
    
    func testMetaInvalidKey() {
        let key = "asdf"
        let instance = Data.sharedInstance
        
        XCTAssertFalse(instance.getMeta(key).count > 0)
    }
    
    /*
        Tests for Data::pullResults()
    */
    func testPullResultsNoParamsNoPrior() {
        let instance = Data.sharedInstance
        XCTAssertFalse(instance.pullResults())
    }
    
    func testPullResultsDefaultParamsNoPrior() {
        let instance = Data.sharedInstance
        XCTAssertTrue(instance.pullResults(Constants.Defaults.get()))
        XCTAssertTrue(instance.results.count > 0)
    }
    
    func testPullResultsFullParamsNoPrior() {
        // need to write full set of sample parameters
    }
    
    func testPullResultsNoParamsPriorSuccess() {
        // can't write this until we have like 20 churches in the database
    }
    
    func testPullResultsFullParamsPriorSuccess() {
        // blocked
    }
    
    func testPullResultsDefault() {
        let instance = Data.sharedInstance
        
        XCTAssertTrue(instance.pullResults(Constants.Defaults.get()))
        
        let results : [Church] = instance.results
        
        XCTAssertTrue(results.count > 0)
        XCTAssertTrue(results.count <= Constants.Defaults.NumberOfResultsToPullAtOnce)
    }
}
