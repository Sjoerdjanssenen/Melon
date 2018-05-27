//
//  MelonTests.swift
//  MelonTests
//
//  Created by Sjoerd Janssen on 27/05/2018.
//  Copyright © 2018 Sjoerd Janssen. All rights reserved.
//

import XCTest
@testable import Melon

class MelonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoadTemplate() {
        if let path = Bundle.main.path(forResource: "first", ofType: "melon") {
            let melon = Melon()
            melon.load(template: path)
        }
    }
    
    func testParseTemplate() {
        if let path = Bundle.main.path(forResource: "first", ofType: "melon") {
            let melon = Melon()
            melon.load(template: path)
            print(melon.parse())
        }
    }
}
