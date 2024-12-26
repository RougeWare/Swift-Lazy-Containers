//
//  GitHubIssue20Tests.swift
//  LazyContainersTests
//
//  Created by Gabe Shahbazian on 2020-07-29.
//

import Testing

import Lazy



nonisolated(unsafe) var shouldNotRun = false

class ShouldNotInit {
    init() {
        shouldNotRun = true
    }
}



/// Guards against issue #20
/// https://github.com/RougeWare/Swift-Lazy-Patterns/issues/20
@Suite(.serialized)
struct GitHubIssue20Tests {
    
    @Lazy
    var lazyShouldNotRun = ShouldNotInit()
    
    @Test
    func testLazyInitWithPropertyWrapper() async throws {
        #expect(false == shouldNotRun)
    }
}
