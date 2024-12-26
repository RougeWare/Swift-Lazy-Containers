//
//  ResettableLazy.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



/// A resettable lazy container, whose value is generated and cached only when first needed, and can be destroyed when
/// no longer needed.
///
/// - Attention: Because of the extra logic and memory required for this behavior, it's recommended that you use `Lazy`
///              or the language's built-in `lazy` instead wherever possible.
@propertyWrapper
public struct ResettableLazy<Value>: LazyContainer {
    
    /// Privatizes the inner-workings of this functional lazy container
    @ValueReference
    private var guts: ResettableValueHolder<Value>
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: ValueReference<ResettableValueHolder<Value>>) {
        self._guts = _guts
    }
    
    
    /// Creates a resettable lazy container with the given value-initializer. That function will be called every time a
    /// value is needed:
    ///
    ///   1. The first time `wrappedValue` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `wrappedValue` will return the cached value
    ///   3. If `clear()` is called, the state is set back to step 1
    ///
    /// - Parameter initializer: The closure that will be called every time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        self.init(_guts: .init(wrappedValue: .unset(initializer: initializer)))
    }
    
    
    /// Same as `init(initializer:)`, but allows you to use property wrapper andor autoclosure semantics
    ///
    /// - Parameter initializer: The closure that will be called every time a value is needed
    public init(wrappedValue initializer: @autoclosure @escaping Initializer<Value>) {
        self.init(initializer: initializer)
    }
    
    
    /// Creates a `ResettableLazy` that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a
    /// `ResettableLazy`), but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in this `ResettableLazy` container
    public static func preinitialized(_ initialValue: Value) -> ResettableLazy<Value> {
        self.init(_guts: .init(wrappedValue: .hasValue(value: initialValue, initializer: { initialValue })))
    }
    
    
    /// Sets or returns the value held within this container.
    ///
    /// If there is none, it is created using the initializer given when this container was created. This process
    /// only happens on the first call to `wrappedValue`;
    /// subsequent calls are guaranteed to return the cached value from the first call.
    ///
    /// You may also use this to set the value manually if you wish.
    /// That value will stay cached until `clear()` is called, after which calls to `wrappedValue` will return the
    /// original value, re-initializing it as necessary.
    public var wrappedValue: Value {
        get { guts.wrappedValue }
        mutating set { guts.wrappedValue = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
    
    
    /// Indicates whether the value has indeed been initialized
    public var isInitialized: Bool { _guts.wrappedValue.hasValue }
    
    
    /// Resets this lazy structure back to its unset state. Next time a value is needed, it will be regenerated using
    /// the initializer given by the constructor
    public func clear() {
        _guts.wrappedValue = .unset(initializer: _guts.wrappedValue.initializer)
    }
}



// MARK: - ResettableValueHolder

/// Takes care of keeping track of the state, value, and initializer of a resettable lazy container, as needed
@propertyWrapper
public enum LazyContainerResettableValueHolder<Value> {
    
    /// Indicates that a value has been cached, and contains that cached value, and the initializer in case the
    /// value is cleared again later on
    case hasValue(value: Value, initializer: Initializer<Value>)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(initializer: Initializer<Value>)
    
    
    /// Finds and returns the initializer held within this enum case
    internal var initializer: Initializer<Value> {
        switch self {
        case .hasValue(value: _, let initializer),
             .unset(let initializer):
            return initializer
        }
    }
    
    
    /// The value held inside this value holder.
    /// - Attention: Reading this value may mutate the state in order to compute the value. The complexity of that read
    ///              operation is equal to the complexity of the initializer.
    public var wrappedValue: Value {
        mutating get {
            switch self {
            case .hasValue(let value, initializer: _):
                return value
                
            case .unset(let initializer):
                let value = initializer()
                self = .hasValue(value: value, initializer: initializer)
                return value
            }
        }
        
        set {
            switch self {
            case .hasValue(value: _, let initializer),
                 .unset(let initializer):
                self = .hasValue(value: newValue, initializer: initializer)
            }
        }
    }
    
    
    /// Indicates whether this holder actually holds a value.
    /// This will be `true` after reading or writing `wrappedValue`.
    public var hasValue: Bool {
        switch self {
        case .hasValue(value: _, initializer: _): return true
        case .unset(initializer: _): return false
        }
    }
}





public extension LazyContainer {
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    ///
    /// - Attention: This will change in version 5, to be an alias to `LazyContainerResettableValueHolder<Value>`
    typealias ResettableValueHolder = LazyContainerResettableValueHolder
}
