//
//  ChurchFinderTests.swift
//  ChurchFinderTests
//
//  Created by Michael Curtis on 2/2/16.
//  Copyright (c) 2016 Michael Curtis. All rights reserved.
//

import UIKit
import XCTest
@testable import ChurchFinder

class ChurchFinderTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testChurchConstructorObject() {
        let id = "A"
        let name = "Test"
        let c = ChurchOld(id: id, name: name)
        
        XCTAssert(c.id == id, "Pass id")
        XCTAssert(c.name == name, "Pass name")
    }
    
    func testGrabChurchList() {
        let s = 0
        let n = 10
        
        let list = GrabChurchList(s, n: n)
        
        XCTAssert(list.count <= 10, "Pass list size")
    }
    
}
