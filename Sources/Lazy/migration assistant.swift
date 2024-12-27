//
//  File.swift
//  LazyContainers
//
//  Created by Ky on 2024-12-26.
//

import Foundation



/// The name which was used for `LazyProtocol` prior to version `6.x` of this package. Included for transition smoothness.
@available(*, deprecated, renamed: "LazyProtocol")
public typealias LazyContainer = LazyProtocol



/// The name which was used for `LazyContainer` in version `1.x` of this package. Included for transition smoothness.
@available(*, unavailable, renamed: "LazyProtocol")
public typealias LazyPattern = LazyProtocol



public extension Lazy {
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls are guaranteed to return the cached value from the first
    /// call.
    @available(*, unavailable, renamed: "wrappedValue",
    message: """
             `Lazy` is now a Swift property wrapper, which requires a `wrappedValue` field.
             Because of this, `value` has been renamed to `wrappedValue`.
             """
    )
    var value: Value {
        get { wrappedValue }
        mutating set { wrappedValue = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
}



public extension ResettableLazy {
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls return the cached value from the first call.
    @available(*, deprecated, renamed: "wrappedValue",
    message: """
             `ResettableLazy` is now a Swift property wrapper, which requires a `wrappedValue` field.
             Because of this, `value` has been renamed to `wrappedValue`.
             """
    )
    var value: Value {
        get { wrappedValue }
        mutating set { wrappedValue = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
}



public extension FunctionalLazy {
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls return the cached value from the first call.
    @available(*, deprecated, renamed: "wrappedValue",
    message: """
             `FunctionalLazy` is now a Swift property wrapper, which requires a `wrappedValue` field.
             Because of this, `value` has been renamed to `wrappedValue`.
             """
    )
    var value: Value {
        get { wrappedValue }
        mutating set { wrappedValue = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
}
