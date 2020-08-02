import XCTest

import LazyContainersTests

let tests: [XCTestCaseEntry] = [
    LazyContainersTests.allTests,
    GitHubIssue20Tests.allTests,
]

XCTMain(tests)
