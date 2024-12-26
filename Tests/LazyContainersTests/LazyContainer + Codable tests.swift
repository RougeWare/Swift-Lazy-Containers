//
//  LazyContainer + Hashable tests.swift
//  
//
//  Created by Ky on 2022-06-03.
//

import Foundation
import Testing

import Lazy



struct LazyContainer_Codable_tests {

    @Test
    func testHashableConformance() throws {
        
        struct Test: Codable {
            
            @Lazy(initializer: { 42 })
            var lazyInt
            
            @FunctionalLazy(initializer: { CGFloat.pi })
            var lazyFloat
            
            @ResettableLazy(initializer: { "foobar" })
            var lazyString
        }
        
        
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        
        #expect(String(data: try encoder.encode(Test()), encoding: .utf8) ==
                #"{"lazyFloat":3.141592653589793,"lazyInt":42,"lazyString":"foobar"}"#)
    }
}
