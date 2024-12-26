//
//  LazyContainer + Hashable.swift
//  
//
//  Created by Ky on 2022-06-03.
//

import Foundation



public extension LazyContainer where Self: Hashable, Value: Hashable {
    func hash(into hasher: inout Hasher) {
        wrappedValue.hash(into: &hasher)
    }
}



extension Lazy: Hashable where Value: Hashable {}
extension ResettableLazy: Hashable where Value: Hashable {}
extension FunctionalLazy: Hashable where Value: Hashable {}
