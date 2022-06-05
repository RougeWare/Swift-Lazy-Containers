//
//  LazyContainer + Hashable tests.swift
//  
//
//  Created by S🌟System on 2022-06-03.
//

import XCTest

import LazyContainers



final class LazyContainer_Hashable_tests: XCTestCase {

    func testHashableConformance() {
        
        struct Test: Hashable {
            
            @Lazy(initializer: { 42 })
            var lazyInt
            
            @FunctionalLazy(initializer: { CGFloat.pi })
            var lazyFloat
            
            @ResettableLazy(initializer: { "foobar" })
            var lazyString
        }
        
        XCTAssertEqual(Test().hashValue, Test().hashValue)
    }
}
