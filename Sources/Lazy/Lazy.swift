//
//  Lazy.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



/// A non-resettable lazy container, to guarantee lazy behavior across language versions
///
/// - Attention: Because of the extra logic and memory required for this behavior, it's recommended that you use the
///              language's built-in `lazy` instead wherever possible.
@propertyWrapper
public struct Lazy<Value>: LazyProtocol {
    
    /// Privatizes the inner-workings of this functional lazy container
    @ValueReference
    private var guts: ValueHolder
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: ValueReference<ValueHolder>) {
        self._guts = _guts
    }
    
    
    /// Creates a non-resettable lazy container with the given value-initializer. That function will be called the very
    /// first time a value is needed:
    ///
    ///   1. The first time `wrappedValue` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `wrappedValue` will return the cached value
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        self.init(_guts: .init(wrappedValue: .unset(initializer: initializer)))
    }


    /// Same as `init(initializer:)`, but allows you to use property wrapper andor autoclosure semantics
    ///
    /// - SeeAlso: https://github.com/RougeWare/Swift-Lazy-Patterns/issues/20
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(wrappedValue initializer: @autoclosure @escaping Initializer<Value>) {
        self.init(initializer: initializer)
    }
    
    
    /// Creates a `Lazy` that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a `Lazy`),
    /// but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in this `Lazy` container
    public static func preinitialized(_ initialValue: Value) -> Lazy<Value> {
        self.init(_guts: .init(wrappedValue: .hasValue(value: initialValue)))
    }
    
    
    /// Returns the value held within this container.
    /// If there is none, it is created using the initializer given when this struct was created. This process only
    /// happens on the first call to `wrappedValue`; subsequent calls are guaranteed to return the cached value from
    /// the first call.
    public var wrappedValue: Value {
        get { guts.wrappedValue }
        mutating set { guts.wrappedValue = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
    
    
    /// Indicates whether the value has indeed been initialized
    public var isInitialized: Bool { _guts.wrappedValue.hasValue }
    
    
    public mutating func initializeNow() {
        guts.initializeNow()
    }
}



// MARK: - ValueHolder

/// Takes care of keeping track of the state, value, and initializer of a lazy container, as needed
@propertyWrapper
public enum LazyContainerValueHolder<Value> {
    
    /// Indicates that a value has been cached, and contains that cached value
    case hasValue(value: Value)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(initializer: Initializer<Value>)
    
    
    /// The value held inside this value holder.
    /// - Attention: Reading this value may mutate the state in order to compute the value. The complexity of that read
    ///              operation is equal to the complexity of the initializer.
    public var wrappedValue: Value {
        mutating get {
            switch self {
            case .hasValue(let value):
                return value
                
            case .unset(let initializer):
                let value = initializer()
                self = .hasValue(value: value)
                return value
            }
        }
        
        set {
            self = .hasValue(value: newValue)
        }
    }
    
    
    /// Indicates whether this holder actually holds a value.
    /// This will be `true` after reading or writing `wrappedValue`.
    public var hasValue: Bool {
        switch self {
        case .hasValue(value: _): return true
        case .unset(initializer: _): return false
        }
    }
    
    
    /// Immediately initializes the value held inside this value holder
    ///
    /// If this holder already contains a value, this does nothing
    mutating func initializeNow()  {
        switch self {
        case .hasValue(_): return
        case .unset(let initializer):
            self = .hasValue(value: initializer())
        }
    }
}




public extension AnyLazy {
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    typealias ValueHolder = LazyContainerValueHolder<Value>
}
