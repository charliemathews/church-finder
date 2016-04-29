/*
Copyright 2016 Serious Llama and Grove City College. All rights reserved.

Author: Charlie Mathews
Created: 25/02/16
Modified: 08/03/16
*/

import XCTest
import Parse
//@testable import ChurchFinder

class DataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    
        //Parse.setApplicationId("OTXY6dM8ChkriarqrX4SPi2e2Def9v1EM0VVNoOW", clientKey: "5I1Iky8vY7hheR7X9QAejEbXaw96UMFBYGzVr4h3")
        //Parse.enableLocalDatastore()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    /*
        Tests for singleton, Data.
    */
    
    // does the shared instance exist?
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
    
    // is the shared instance persistent?
    func testSharedInstance_Twice() {
        let instance1 = Data.sharedInstance
        let instance2 = Data.sharedInstance
        XCTAssertTrue(instance1 === instance2)
    }
    
    // is the singleton thread safe?
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
    
    // I couldn't get this test to run in this environment because the function passed to 
    // parse findObjectsInBackgroundWithBlock is never being run in the test environment.
    /*
    func testMetaValidKey() {
        let key = "denomination"
        let instance = Data.sharedInstance
        instance.getMeta(key)
        sleep(10)
        //while(instance.meta_success == false && instance.error == false) {}
        if let count = instance.filterData[key]?.count as Int! {
            XCTAssertTrue(count > 0)
        } else {
            XCTAssertFalse(true)
        }
    }
    */
    
    func testMetaInvalidKey() {
        let key = "asdf"
        let instance = Data.sharedInstance
        instance.getMeta(key)
        sleep(5)
        
        XCTAssertTrue(instance.filterData[key] == nil)
    }
    
    /*
        Tests for Data::pullResults()
    */
    func testPullResultsNoParamsNoPrior() {
        let instance = Data.sharedInstance
        instance.pullResults()
        sleep(1)
        while(instance.threadQueryLock == true) {}
        XCTAssertTrue(instance.results.count == 0)
    }
    
    
    // None of the following tests would work because the parse query.runqueryinbackground won't run in the testing environment.
    /*
    func testPullResultsDefaultParamsNoPrior() {
        let instance = Data.sharedInstance
        instance.pullResults(Constants.Defaults.get())
        sleep(1)
        while(instance.threadQueryLock == true) {}
        XCTAssertTrue(instance.results.count > 0)
    }
    
    func testPullResultsNoParamsPriorSuccess() {
        let instance = Data.sharedInstance
        instance.pullResults(Constants.Defaults.get())
        sleep(1)
        while(instance.threadQueryLock == true) {}
        XCTAssertTrue(instance.results.count > 0)
        instance.pullResults()
        sleep(1)
        while(instance.threadQueryLock == true) {}
        XCTAssertTrue(instance.results.count > 0)
    }
    
    func testPullResultsFullParamsPriorSuccess() {
        //
    }
     */
    
    func testClearData() {
        let instance = Data.sharedInstance
        instance.results.append(Church())
        instance.currentParameters = Constants.Defaults.get()
        instance.clear()
        XCTAssertTrue(instance.results.count == 0)
        XCTAssertTrue(instance.currentParameters.count == 0)
    }
}
