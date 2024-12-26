//
//  LazyContainer + Hashable tests.swift
//  
//
//  Created by Ky on 2022-06-03.
//

import Foundation
import Testing

import Lazy



struct LazyContainer_Hashable_tests {

    @Test
    func testHashableConformance() {
        
        struct Test: Hashable {
            
            @Lazy(initializer: { 42 })
            var lazyInt
            
            @FunctionalLazy(initializer: { CGFloat.pi })
            var lazyFloat
            
            @ResettableLazy(initializer: { "foobar" })
            var lazyString
        }
        
        #expect(Test().hashValue == Test().hashValue)
    }
}
