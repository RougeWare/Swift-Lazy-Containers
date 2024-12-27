//
//  AsyncLazyProtocol.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



/// Simply initializes a value
public typealias AsyncInitializer<Value> = @Sendable () async -> Value



/// Defines how a lazy container should look when it performs all its operations asynchronously
public protocol AsyncLazyProtocol: AnyLazy {
    
    /// Gets the value, possibly initializing it first
    mutating func get() async -> Value
    
    
    /// Sets the value asynchronously
    mutating func set(to newValue: sending Value) async // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    
    
    /// Mutate the value within the context of this container
    /// - Parameter isolatedMutator: Mutates the wrapped value within the proper isolation context
    mutating func mutate(_ isolatedMutator: (inout Value) async -> Void) async
    
    
    /// Indicates whether the value has indeed been initialized
    var isInitialized: Bool { get async }
    
    
    /// Immediately initializes the value held inside this lazy container
    ///
    /// If this holder already contains a value, this does nothing
    // https://github.com/RougeWare/Swift-Lazy-Containers/issues/40
    mutating func initializeNow() async
    
    
    /// Creates a lazy container that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a `Lazy`),
    /// but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in the otherwise-lazy container
    static func preinitialized(_ initialValue: Value) -> Self
}



// MARK: - ValueReference

/// Allows you to use reference-semantics to hold a value inside a lazy container
//@propertyWrapper // Property wrappers currently cannot define an 'async' or 'throws' accessor
public final actor LazyAsyncValueReference<Value: Sendable & Copyable> {
    
    /// Holds some value- or reference-passed instance inside a reference-passed one
    public var wrappedValue: Value
    
    
    /// Creates a reference to the given value- or reference-passed instance
    ///
    /// - Parameter wrappedValue: The instance to wrap
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    
    func set(to newValue: Value) {
        wrappedValue = newValue
    }
    
    
    func mutate(_ isolatedMutator: @Sendable (inout Value) async -> Void) async {
        var wrappedValue = self.wrappedValue
        await isolatedMutator(&wrappedValue)
        self.wrappedValue = wrappedValue
    }
}



public extension AnyLazy {
    
    /// Allows you to use reference semantics to hold a value inside a lazy container.
    typealias AsyncValueReference = LazyAsyncValueReference
}

