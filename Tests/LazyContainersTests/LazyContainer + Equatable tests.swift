//
//  LazyContainer + Equatable tests.swift
//  
//
//  Created by Ky on 2022-06-03.
//

import Foundation
import Testing

import Lazy



struct LazyContainer_Equatable_tests {

    @Test
    func testEquatableConformance() {
        
        struct Test: Equatable {
            
            @Lazy(initializer: { 42 })
            var lazyInt
            
            @FunctionalLazy(initializer: { CGFloat.pi })
            var lazyFloat
            
            @ResettableLazy(initializer: { "foobar" })
            var lazyString
        }
        
        #expect(Test() == Test())
    }
}
