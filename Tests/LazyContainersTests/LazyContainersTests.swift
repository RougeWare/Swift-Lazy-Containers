//
//  LazyContainersTests.swift
//
//  Created by Ben Leggiero on 2019-08-19
//  Copyright BH-0-PD © 2019 - https://github.com/BlueHuskyStudios/Licenses/blob/master/Licenses/BH-0-PD.txt
//



import XCTest
@testable import LazyContainers



var sideEffectA: String?
func makeLazyA() -> String {
    sideEffectA = "Side effect A1"
    return "lAzy"
}

var sideEffectB: String?
func makeLazyB() -> String {
    sideEffectB = "Side effect B"
    return "Lazy B (this time with side-effects)"
}



final class LazyContainersTests: XCTestCase {
    
    #if swift(>=5.3)
    @Lazy(initializer: makeLazyA)
    var lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect: String
    #endif
    
    var lazyInitTraditionally = Lazy<String>() {
        sideEffectA = "Side effect A2"
        return "lazy B"
    }
    
    @ResettableLazy
    var resettableLazyInitWithPropertyWrapper = "lazy C"
    
    var resettableLazyInitTraditionally = ResettableLazy(wrappedValue: "lazy D")
    
    @FunctionalLazy
    var functionalLazyInitWithPropertyWrapper = "lazy E"
    
    var functionalLazyInitTraditionally = FunctionalLazy(wrappedValue: "lazy F")
    

    override func setUp() {
        sideEffectA = nil
        sideEffectB = nil
    }
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    
    // MARK: - `Lazy`
    
    #if swift(>=5.3)
    func testLazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect() {
        XCTAssertEqual(sideEffectA, nil)
        XCTAssertFalse(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, nil)
        XCTAssertEqual("lAzy", lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertEqual("lAzy", lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertEqual("lAzy", lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        
        lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect = "MAnual"
        
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertEqual("MAnual", lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertEqual("MAnual", lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertEqual("MAnual", lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        XCTAssertEqual(sideEffectA, "Side effect A1")
        XCTAssertTrue(_lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        XCTAssertEqual(sideEffectA, "Side effect A1")
    }
    
    
    func testLazyInitWithPropertyWrapperAndSideEffect() {
        
        struct Test {
            @Lazy
            var lazyInitWithPropertyWrapperAndSideEffect = makeLazyB()
        }
        
        
        let test = Test()
        
        XCTAssertNil(sideEffectB, "@Lazy eagerly evaluated its initial value")
        XCTAssertEqual(test.lazyInitWithPropertyWrapperAndSideEffect, "Lazy B (this time with side-effects)")
    }
    #endif
    
    
    func testLazyInitTraditionally() {
        XCTAssertFalse(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("lazy B", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        
        lazyInitTraditionally.wrappedValue = "Manual B"
        
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        
        lazyInitTraditionally.value = "Manual B2"
        
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B2", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B2", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B2", lazyInitTraditionally.wrappedValue)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B2", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B2", lazyInitTraditionally.value)
        XCTAssertTrue(lazyInitTraditionally.isInitialized)
        XCTAssertEqual("Manual B2", lazyInitTraditionally.value)
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
    
    #if swift(>=5.3)
    static let testsWhichRequireSwift5_3 = [
        ("testLazyInitWithPropertyWrapperWithCustomInitializerAndSideEffect", testLazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect),
        ("testLazyInitWithPropertyWrapperAndSideEffect", testLazyInitWithPropertyWrapperAndSideEffect),
    ]
    #endif
    
    
    static let testsWhichWorkBeforeSwift5_3 = [
        ("testLazyInitTraditionally", testLazyInitTraditionally),
        
        ("testResettableLazyInitWithPropertyWrapper", testResettableLazyInitWithPropertyWrapper),
        ("testResettableLazyInitTraditionally", testResettableLazyInitTraditionally),
        
        ("testFunctionalLazyInitWithPropertyWrapper", testFunctionalLazyInitWithPropertyWrapper),
        ("testFunctionalLazyInitTraditionally", testFunctionalLazyInitTraditionally),
    ]
    
    
    #if swift(>=5.3)
    static let allTests = testsWhichRequireSwift5_3 + testsWhichWorkBeforeSwift5_3
    #else
    @inline(__always)
    static let allTests = testsWhichWorkBeforeSwift5_3
    #endif
}
