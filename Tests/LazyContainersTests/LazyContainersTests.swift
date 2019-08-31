//
//  LazyContainersTests.swift
//
//  Created by Ben Leggiero on 2019-08-19
//  Copyright BH-0-PD © 2019 - https://github.com/BlueHuskyStudios/Licenses/blob/master/Licenses/BH-0-PD.txt
//



import XCTest
@testable import LazyContainers



var sideEffect: String?

func makeLazyA() -> String {
    sideEffect = "Side effect A"
    return "lAzy"
}



final class LazyContainersTests: XCTestCase {
    
    @Lazy(initializer: makeLazyA)
    var lazyInitWithPropertyWrapper: String
    
    var lazyInitTraditionally = Lazy<String>() {
        sideEffect = "Side effect B"
        return "lazy B"
    }
    
    @ResettableLazy
    var resettableLazyInitWithPropertyWrapper = "lazy C"
    
    var resettableLazyInitTraditionally = ResettableLazy(wrappedValue: "lazy D")
    
    @FunctionalLazy
    var functionalLazyInitWithPropertyWrapper = "lazy E"
    
    var functionalLazyInitTraditionally = FunctionalLazy(wrappedValue: "lazy F")
    

    override func setUp() {
        sideEffect = nil
    }
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    // MARK: - `Lazy`
    
    func testLazyInitWithPropertyWrapper() {
        XCTAssertEqual(sideEffect, nil)
        XCTAssertFalse(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, nil)
        XCTAssertEqual("lAzy", lazyInitWithPropertyWrapper)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertEqual("lAzy", lazyInitWithPropertyWrapper)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertEqual("lAzy", lazyInitWithPropertyWrapper)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
        
        lazyInitWithPropertyWrapper = "MAnual"
        
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertEqual("MAnual", lazyInitWithPropertyWrapper)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertEqual("MAnual", lazyInitWithPropertyWrapper)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertEqual("MAnual", lazyInitWithPropertyWrapper)
        XCTAssertEqual(sideEffect, "Side effect A")
        XCTAssertTrue(_lazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual(sideEffect, "Side effect A")
    }
    
    
    func testLazyInitTraditionally() {
        XCTAssertFalse(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        
        lazyInitTraditionally.wrappedValue = "Manual B"
        
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
    }
    
    
    
    // MARK: - `ResettableLazy`
    
    func testResettableLazyInitWithPropertyWrapper() {
        XCTAssertFalse(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        
        resettableLazyInitWithPropertyWrapper = "Manual C"
        
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("Manual C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("Manual C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("Manual C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        
        _resettableLazyInitWithPropertyWrapper.clear()
        
        XCTAssertFalse(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy C", resettableLazyInitWithPropertyWrapper)
        XCTAssertTrue(_resettableLazyInitWithPropertyWrapper.isInitialized)
    }
    
    
    func testResettableLazyInitTraditionally() {
        XCTAssertFalse(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        
        resettableLazyInitTraditionally.wrappedValue = "Manual D"
        
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        
        resettableLazyInitTraditionally.clear()
        
        XCTAssertFalse(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy D", resettableLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(resettableLazyInitTraditionally.isInitialized)
    }
    
    
    
    // MARK: - `FuctionalLazy`
    
    func testFunctionalLazyInitWithPropertyWrapper() {
        XCTAssertFalse(_functionalLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy E", functionalLazyInitWithPropertyWrapper)
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy E", functionalLazyInitWithPropertyWrapper)
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("lazy E", functionalLazyInitWithPropertyWrapper)
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
        
        functionalLazyInitWithPropertyWrapper = "Manual E"
        
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("Manual E", functionalLazyInitWithPropertyWrapper)
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("Manual E", functionalLazyInitWithPropertyWrapper)
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
        XCTAssertEqual("Manual E", functionalLazyInitWithPropertyWrapper)
        XCTAssertTrue(_functionalLazyInitWithPropertyWrapper.isInitialized)
    }
    
    
    func testFunctionalLazyInitTraditionally() {
        XCTAssertFalse(functionalLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy F", functionalLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy F", functionalLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy F", functionalLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
        
        functionalLazyInitTraditionally.wrappedValue = "Manual F"
        
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual F", functionalLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual F", functionalLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual F", functionalLazyInitTraditionally.wrappedValue)
        XCTAssertTrue(functionalLazyInitTraditionally.isInitialized)
    }

    static var allTests = [
        ("testLazyInitWithPropertyWrapper", testLazyInitWithPropertyWrapper),
        ("testLazyInitTraditionally", testLazyInitTraditionally),
        
        ("testResettableLazyInitWithPropertyWrapper", testResettableLazyInitWithPropertyWrapper),
        ("testResettableLazyInitTraditionally", testResettableLazyInitTraditionally),
        
        ("testFunctionalLazyInitWithPropertyWrapper", testFunctionalLazyInitWithPropertyWrapper),
        ("testFunctionalLazyInitTraditionally", testFunctionalLazyInitTraditionally),
    ]
}
