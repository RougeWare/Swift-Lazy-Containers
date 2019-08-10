//
//  LazyTests.swift
//  Swift-Lazy-PatternsTests
//
//  Created by Ben Leggiero on 8/7/19.
//

import XCTest
@testable import Swift_Lazy_Patterns

class LazyTests: XCTestCase {
    
    @Lazy
    var a = "lAze"
    
    let b = Lazy { "lazy B" }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFoo() {
        XCTAssertEqual("laze", a.value)
    }
}
