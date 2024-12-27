//
//  LazyProtocol.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



// MARK: - Supporting types

/// Simply initializes a value
public typealias Initializer<Value> = () -> Value



// MARK: -

/// Defines how a lazy container should look
public protocol LazyProtocol: AsyncLazyProtocol {
    
    /// Gets the value, possibly initializing it first
    var wrappedValue: Value {
        get
        mutating set // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
    
    
    /// Indicates whether the value has indeed been initialized
    var isInitialized: Bool { get }
    
    
    /// Immediately initializes the value held inside this lazy container
    ///
    /// If this holder already contains a value, this does nothing
    // https://github.com/RougeWare/Swift-Lazy-Containers/issues/40
    mutating func initializeNow()
    
    
    /// Creates a lazy container that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a `Lazy`),
    /// but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in the otherwise-lazy container
    static func preinitialized(_ initialValue: Value) -> Self
}



public extension LazyProtocol {
    @available(*, deprecated, message: "This is not required for non-Async `LazyContainer`s")
    mutating func set(to newValue: Value) {
        wrappedValue = newValue
    }
}



// MARK: - ValueReference

/// Allows you to use reference-semantics to hold a value inside a lazy container
@propertyWrapper
public final class LazyContainerValueReference<Value> {
    
    /// Holds some value- or reference-passed instance inside a reference-passed one
    public var wrappedValue: Value
    
    
    /// Creates a reference to the given value- or reference-passed instance
    ///
    /// - Parameter wrappedValue: The instance to wrap
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}



public extension AnyLazy {
    
    /// Allows you to use reference semantics to hold a value inside a lazy container.
    typealias ValueReference = LazyContainerValueReference
}
