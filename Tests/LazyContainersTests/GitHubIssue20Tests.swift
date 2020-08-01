//
//  GitHubIssue20Tests.swift
//  LazyContainersTests
//
//  Created by Ben Leggiero on 2020-07-29.
//

import XCTest
@testable import LazyContainers



#if swift(>=5.3)
var shouldNotRun = false

class ShouldNotInit {
    init() {
        shouldNotRun = true
    }
}



/// Guards against issue #20
/// https://github.com/RougeWare/Swift-Lazy-Patterns/issues/20
final class GitHubIssue20Tests: XCTestCase {
    
    @Lazy
    var lazyShouldNotRun = ShouldNotInit()
    
    func testLazyInitWithPropertyWrapper() {
        XCTAssertFalse(shouldNotRun)
    }
    
    static var allTests = [
        ("testLazyInitWithPropertyWrapper", testLazyInitWithPropertyWrapper)
    ]
}
#endif
