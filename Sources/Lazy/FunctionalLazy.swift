//
//  FunctionalLazy.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



/// An idea about how to approach the lazy container by using functions instead of branches.
///
/// - Attention: This is theoretically thread-safe, but hasn't undergone rigorous real-world testing. A short-lived
///              semaphore was added to mitigate this, but again, it hasn't undergone rigorous real-world testing.
@propertyWrapper
public struct FunctionalLazy<Value>: LazyProtocol {
    
    /// Privatizes the inner-workings of this functional lazy container
    @Guts
    private var guts: Value
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: Guts) {
        self._guts = _guts
    }
    
    
    /// Creates a non-resettable lazy container (implemented with functions!) with the given value-initializer. That
    /// function will be called the very first time a value is needed:
    ///
    ///   1. The first time `wrappedValue` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `wrappedValue` will return the cached value
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        self.init(_guts: .init(initializer: initializer))
    }
    
    
    /// Same as `init(initializer:)`, but allows you to use property wrapper andor autoclosure semantics
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(wrappedValue initializer: @autoclosure @escaping Initializer<Value>) {
        self.init(initializer: initializer)
    }
    
    
    /// Creates a `FunctionalLazy` that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a
    /// `FunctionalLazy`), but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in this `FunctionalLazy` container
    public static func preinitialized(_ initialValue: Value) -> FunctionalLazy<Value> {
        self.init(_guts: .init(initializer: { initialValue }))
    }
    
    
    /// Returns the value held within this container.
    /// If there is none, it is created using the initializer given when this container was created. This process
    /// only happens on the first call to `wrappedValue`; subsequent calls return the cached value from the first call,
    /// or any value you've set this to.
    public var wrappedValue: Value {
        get { guts }
        mutating set { guts = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
    
    
    /// Indicates whether the value has indeed been initialized
    public var isInitialized: Bool { _guts.isInitialized }
    
    
    public mutating func initializeNow() {
        _guts.initializeNow()
    }
    
    
    
    /// The actual functionality of `FunctionalLazy`, separated so that the semantics work out better
    @propertyWrapper
    private final class Guts {
        
        /// The closure called every time a value is needed
        var initializer: Initializer<Value>
        
        /// Guarantees that, on first-init, only one thread initializes the value. After that, this is set to `nil`
        /// because subsequent threads can safely access the value without the risk of setting it again.
        var semaphore: DispatchSemaphore? = .init(value: 1)
        

        /// Creates a non-resettable lazy container's guts with the given value-initializer. That function will be
        /// called the very first time a value is needed.
        init(initializer: @escaping Initializer<Value>) {
            self.initializer = initializer
            self.initializer = {
                let semaphore = self.semaphore
                semaphore?.wait()
                
                let initialValue = initializer()
                self.initializer = { initialValue }
                
                semaphore?.signal()
                self.semaphore = nil
                
                return initialValue
            }
        }
        

        /// Returns the value held within this container.
        /// If there is none, it is created using the initializer given when these guts were created. This process
        /// only happens on the first call to `wrappedValue`; subsequent calls return the cached value from the first
        /// call, or any value you've set this to.
        var wrappedValue: Value {
            get { initializer() }
            set { initializer = { newValue } }
        }
        
        
        func initializeNow() {
            _ = initializer()
        }
        

        /// Indicates whether the value has indeed been initialized
        public var isInitialized: Bool { nil == semaphore }
    }
}

