//
//  LazyContainer + Equatable.swift
//  
//
//  Created by Ky on 2022-06-03.
//

import Foundation



// MARK: - Encodable

public extension LazyContainer where Self: Encodable, Value: Encodable {
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}



extension Lazy: Encodable where Value: Encodable {}
extension ResettableLazy: Encodable where Value: Encodable {}
extension FunctionalLazy: Encodable where Value: Encodable {}



// MARK: - Decodable

public extension LazyContainer where Self: Decodable, Value: Decodable {
    init(from decoder: Decoder) throws {
        self = .preinitialized(try Value(from: decoder))
    }
}



extension Lazy: Decodable where Value: Decodable {}
extension ResettableLazy: Decodable where Value: Decodable {}
extension FunctionalLazy: Decodable where Value: Decodable {}
