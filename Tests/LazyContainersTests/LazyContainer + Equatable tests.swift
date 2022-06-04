//
//  LazyContainer + Equatable tests.swift
//  
//
//  Created by S🌟System on 2022-06-03.
//

import XCTest

import LazyContainers



final class LazyContainer_Equatable_tests: XCTestCase {

    func testEquatableConformance() {
        
        struct Test: Equatable {
            
            @Lazy(initializer: { 42 })
            var lazyInt
            
            @FunctionalLazy(initializer: { CGFloat.pi })
            var lazyFloat
            
            @ResettableLazy(initializer: { "foobar" })
            var lazyString
        }
        
        XCTAssertEqual(Test(), Test())
    }
}
