//
//  Lazy.swift
//  Lazy in Swift 4
//
//  Created by Ben Leggiero on 2018-05-04.
//  Version 1.1.0 (last edited 2018-05-04)
//  Copyright CC0 © 2018 - https://creativecommons.org/publicdomain/zero/1.0/
//

import Foundation



/// Simply initializes a value
public typealias Initializer<Value> = () -> Value



/// Defines how a lazy pattern should look
public protocol LazyPattern {
    
    /// The type of the value that will be lazily-initialized
    associatedtype Value
    
    /// Gets the value, possibly initializing it first
    var value: Value { mutating get }
}



/// A non-resettable lazy pattern, to guarantee lazy behavior across language versions
public struct Lazy<_Value>: LazyPattern {
    
    public typealias Value = _Value
    
    
    
    /// Holds the internal value of this `Lazy`
    private var valueHolder: ValueHolder<Value>
    
    
    /// Creates a non-resettable lazy with the given value initializer. That closure will be called the very first time
    /// a value is needed:
    ///
    ///   1. The first time `value` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `value` will return the cached value
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        valueHolder = .unset(initializer)
    }
    
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls are guaranteed to return the cached value from the first
    /// call.
    public var value: Value {
        mutating get {
            switch valueHolder {
            case .hasValue(let value):
                return value
                
            case .unset(let initializer):
                let value = initializer()
                valueHolder = .hasValue(value)
                return value
            }
        }
    }
}



// NOTE: This would be nested within `Lazy`, but that caused a runtime crash documented in
// https://bugs.swift.org/browse/SR-7604
/// Takes care of keeping track of the state, value, and initializer as needed
private enum ValueHolder<Value> {
    /// Indicates that a value has been cached, and contains that cached value
    case hasValue(Value)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(Initializer<Value>)
}



/// A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when
/// no longer needed.
///
/// - Attention: Because of the extra logic and memory required for this behavior, it's recommended that you use `Lazy`
///              instead wherever possible.
public struct ResettableLazy<_Value>: LazyPattern {
    
    public typealias Value = _Value
    
    
    
    /// Holds the internal value of this `Lazy`
    private var valueHolder: ResettableValueHolder<Value>
    
    
    /// Creates a resettable lazy pattern with the given value initializer. That closure will be called every time a
    /// value is needed:
    ///
    ///   1. The first time `value` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `value` will return the cached value
    ///   3. If `clear()` is called, the state is set back to step 1
    ///
    /// - Parameter initializer: The closure that will be called every time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        valueHolder = .unset(initializer)
    }
    
    
    /// Sets or returns the value held within this struct.
    ///
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`;
    /// subsequent calls are guaranteed to return the cached value from the first call.
    ///
    /// You may also use this to set the value manually if you wish.
    /// That value will stay cached until `clear()` is called.
    public var value: Value {
        mutating get {
            switch valueHolder {
            case .hasValue(let value, _):
                return value
                
            case .unset(let initializer):
                let value = initializer()
                valueHolder = .hasValue(value, initializer)
                return value
            }
        }
        
        set {
            valueHolder = .hasValue(newValue, valueHolder.initializer)
        }
    }
    
    
    /// Resets this lazy structure back to its unset state. Next time a value is needed, it will be regenerated using
    /// the initializer given by the constructor
    public mutating func clear() {
        valueHolder = .unset(valueHolder.initializer)
    }
}



// NOTE: This would be nested within `ResettableLazy`, but that caused a runtime crash documented in
// https://bugs.swift.org/browse/SR-7604
/// Takes care of keeping track of the state, value, and initializer as needed
private enum ResettableValueHolder<Value> {
    /// Indicates that a value has been cached, and contains that cached value, and the initializer in case the
    /// value is cleared again later on
    case hasValue(Value, Initializer<Value>)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(Initializer<Value>)
    
    /// Finds and returns the initializer held within this enum case
    var initializer: Initializer<Value> {
        switch self {
        case .hasValue(_, let initializer),
             .unset(let initializer):
            return initializer
        }
    }
}



/// An idea about how to approach the lazy pattern by using functions instead of branches.
///
/// - Attention: This is theoretically thread-safe, but hasn't undergone rigorous testing. The other two lazy patterns
///              in this file are `structs`, which means their value-passed nature gives them natural thread-safety,
///              whereas this is a `class`, which makes its reference-passed nature exposes it to possible
///              thread-unsafety. A short-lived semaphore was added to mitigate this, but again, it hasn't undergone
///              rigorous testing.
public class FunctionalLazy<_Value>: LazyPattern {
    
    public typealias Value = _Value
    
    
    
    /// The closure called every time a value is needed
    private var valueHolder: Initializer<Value>! = nil
    
    /// Guarantees that, on first-init, only one thread initializes the value. After that, this is set to `nil` because
    /// subsequent threads can safely access the value without setting it again.
    private var semaphore: DispatchSemaphore? = .init(value: 1)
    
    
    /// Creates a non-resettable lazy with the given value initializer. That closure will be called the very first time
    /// a value is needed:
    ///
    ///   1. The first time `value` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `value` will return the cached value
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        valueHolder = initializer
        valueHolder = {
            self.semaphore?.wait()
            
            let initialValue = self.valueHolder()
            self.valueHolder = { initialValue }
            
            self.semaphore?.signal()
            self.semaphore = nil
            
            return initialValue
        }
    }
    
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls return the cached value from the first call.
    public var value: Value {
        return valueHolder()
    }
}
