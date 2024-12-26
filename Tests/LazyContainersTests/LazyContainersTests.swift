//
//  LazyContainersTests.swift
//  LazyContainersTests
//
//  Created by Ky on 2019-08-19
//  Copyright waived. No rights reserved.
//  https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/LICENSE.txt
//

import Testing
import Lazy



nonisolated(unsafe) var sideEffectA: String?
func makeLazyA() -> String {
    sideEffectA = "Side effect A1"
    return "lAzy"
}

nonisolated(unsafe) var sideEffectB: String?
func makeLazyB() -> String {
    sideEffectB = "Side effect B"
    return "Lazy B (this time with side-effects)"
}



@Suite(.serialized)
struct LazyContainersTests {
    
    @Lazy(initializer: makeLazyA)
    var lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect: String
    
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
    

    init() {
        sideEffectA = nil
        sideEffectB = nil
    }
    
    
    
    // MARK: - `Lazy`
    
    @Test
    mutating func testLazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect() {
        #expect(sideEffectA == nil)
        #expect(false == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == nil)
        #expect("lAzy" == lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
        #expect("lAzy" == lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
        #expect("lAzy" == lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
        
        lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect = "MAnual"
        
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
        #expect("MAnual" == lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
        #expect("MAnual" == lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
        #expect("MAnual" == lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect)
        #expect(sideEffectA == "Side effect A1")
        #expect(true == _lazyInitWithPropertyWrapperAndCustomInitializerWithSideEffect.isInitialized)
        #expect(sideEffectA == "Side effect A1")
    }
    
    
    @Test
    func testLazyInitWithPropertyWrapperAndSideEffect() {
        
        struct Test {
            @Lazy
            var lazyInitWithPropertyWrapperAndSideEffect = makeLazyB()
        }
        
        
        let test = Test()
        
        #expect(nil == sideEffectB, "@Lazy eagerly evaluated its initial value")
        #expect(test.lazyInitWithPropertyWrapperAndSideEffect == "Lazy B (this time with side-effects)")
    }
    
    
    @Test
    mutating func testLazyInitTraditionally() {
        #expect(false == lazyInitTraditionally.isInitialized)
        #expect("lazy B" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("lazy B" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("lazy B" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        
        lazyInitTraditionally.wrappedValue = "Manual B"
        
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("Manual B" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("Manual B" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("Manual B" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        
        lazyInitTraditionally.wrappedValue = "Manual B2"
        
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("Manual B2" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("Manual B2" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
        #expect("Manual B2" == lazyInitTraditionally.wrappedValue)
        #expect(true == lazyInitTraditionally.isInitialized)
    }
    
    
    
    // MARK: - `ResettableLazy`
    
    @Test
    mutating func testResettableLazyInitWithPropertyWrapper() {
        #expect(false == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        
        resettableLazyInitWithPropertyWrapper = "Manual C"
        
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("Manual C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("Manual C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("Manual C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        
        _resettableLazyInitWithPropertyWrapper.clear()
        
        #expect(false == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy C" == resettableLazyInitWithPropertyWrapper)
        #expect(true == _resettableLazyInitWithPropertyWrapper.isInitialized)
    }
    
    
    @Test
    mutating func testResettableLazyInitTraditionally() {
        #expect(false == resettableLazyInitTraditionally.isInitialized)
        #expect("lazy D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("lazy D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("lazy D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        
        resettableLazyInitTraditionally.wrappedValue = "Manual D"
        
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("Manual D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("Manual D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("Manual D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        
        resettableLazyInitTraditionally.clear()
        
        #expect(false == resettableLazyInitTraditionally.isInitialized)
        #expect("lazy D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("lazy D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
        #expect("lazy D" == resettableLazyInitTraditionally.wrappedValue)
        #expect(true == resettableLazyInitTraditionally.isInitialized)
    }
    
    
    
    // MARK: - `FuctionalLazy`
    
    @Test
    mutating func testFunctionalLazyInitWithPropertyWrapper() {
        #expect(false == _functionalLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy E" == functionalLazyInitWithPropertyWrapper)
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy E" == functionalLazyInitWithPropertyWrapper)
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
        #expect("lazy E" == functionalLazyInitWithPropertyWrapper)
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
        
        functionalLazyInitWithPropertyWrapper = "Manual E"
        
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
        #expect("Manual E" == functionalLazyInitWithPropertyWrapper)
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
        #expect("Manual E" == functionalLazyInitWithPropertyWrapper)
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
        #expect("Manual E" == functionalLazyInitWithPropertyWrapper)
        #expect(true == _functionalLazyInitWithPropertyWrapper.isInitialized)
    }
    
    
    @Test
    mutating func testFunctionalLazyInitTraditionally() {
        #expect(false == functionalLazyInitTraditionally.isInitialized)
        #expect("lazy F" == functionalLazyInitTraditionally.wrappedValue)
        #expect(true == functionalLazyInitTraditionally.isInitialized)
        #expect("lazy F" == functionalLazyInitTraditionally.wrappedValue)
        #expect(true == functionalLazyInitTraditionally.isInitialized)
        #expect("lazy F" == functionalLazyInitTraditionally.wrappedValue)
        #expect(true == functionalLazyInitTraditionally.isInitialized)
        
        functionalLazyInitTraditionally.wrappedValue = "Manual F"
        
        #expect(true == functionalLazyInitTraditionally.isInitialized)
        #expect("Manual F" == functionalLazyInitTraditionally.wrappedValue)
        #expect(true == functionalLazyInitTraditionally.isInitialized)
        #expect("Manual F" == functionalLazyInitTraditionally.wrappedValue)
        #expect(true == functionalLazyInitTraditionally.isInitialized)
        #expect("Manual F" == functionalLazyInitTraditionally.wrappedValue)
        #expect(true == functionalLazyInitTraditionally.isInitialized)
    }
}
