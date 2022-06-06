//
//  LazyContainer + Hashable tests.swift
//  
//
//  Created by S🌟System on 2022-06-03.
//

import XCTest

import LazyContainers



final class LazyContainer_Codable_tests: XCTestCase {

    func testHashableConformance() {
        
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
        
        XCTAssertEqual(String(data: try encoder.encode(Test()), encoding: .utf8),
                       #"{"lazyFloat":3.1415926535897931,"lazyInt":42,"lazyString":"foobar"}"#)
    }
}
