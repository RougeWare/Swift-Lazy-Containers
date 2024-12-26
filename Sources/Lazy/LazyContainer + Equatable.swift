//
//  LazyContainer + Equatable.swift
//  
//
//  Created by Ky on 2022-06-03.
//

import Foundation



public extension LazyContainer where Self: Equatable, Value: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
    
    
    static func == (lhs: Self, rhs: Value) -> Bool {
        lhs.wrappedValue == rhs
    }
    
    
    static func == (lhs: Value, rhs: Self) -> Bool {
        lhs == rhs.wrappedValue
    }
}



extension Lazy: Equatable where Value: Equatable {}
extension ResettableLazy: Equatable where Value: Equatable {}
extension FunctionalLazy: Equatable where Value: Equatable {}
