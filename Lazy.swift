//
//  Lazy.swift
//  Lazy in Swift 4
//
//  Created by Ben Leggiero on 2018-05-04.
//  Version 2.2.0 (last edited 2019-08-09)
//  Copyright CC0 © 2018 - https://creativecommons.org/publicdomain/zero/1.0/
//

import Foundation



// MARK: - Supporting types

/// Simply initializes a value
public typealias Initializer<Value> = () -> Value



/// Defines how a lazy pattern should look
public protocol LazyContainer {
    
    /// The type of the value that will be lazily-initialized
    associatedtype Value
    
    /// Gets the value, possibly initializing it first
    var value: Value { mutating get }
    
    
    /// Creates a lazy container that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a `Lazy`),
    /// but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in the otherwise-lazy container
    init(initialValue: Value)
}



/// The name which was used for `LazyContainer` in version `1.x` of this API. Included for transition smoothness.
public typealias LazyPattern = LazyContainer



public extension LazyContainer {
    /// Allows you to use reference semantics to hold a value inside a lazy container
    typealias ValueReference = LazyContainerValueReference
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    typealias ValueHolder = LazyContainerValueHolder
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    typealias ResettableValueHolder = LazyContainerResettableValueHolder
}



/// Allows you to use reference semantics to hold a value inside a lazy container
@propertyWrapper
public class LazyContainerValueReference<Value> {
    
    /// Holds some value- or reference-passed instance inside a reference-passed one
    public var wrappedValue: Value
    
    
    /// Creates a reference to the given value- or reference-passed instance
    ///
    /// - Parameter wrappedValue: The instance to wrap
    public init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
}



/// Takes care of keeping track of the state, value, and initializer as needed
@propertyWrapper
public enum LazyContainerValueHolder<Value> {
    
    /// Indicates that a value has been cached, and contains that cached value
    case hasValue(Value)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(Initializer<Value>)
    
    
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
                self = .hasValue(value)
                return value
            }
        }
        
        set {
            self = .hasValue(newValue)
        }
    }
}



/// Takes care of keeping track of the state, value, and initializer as needed
@propertyWrapper
public enum LazyContainerResettableValueHolder<Value> {
    
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
    
    
    /// The value held inside this value holder.
    /// - Attention: Reading this value may mutate the state in order to compute the value. The complexity of that read
    ///              operation is equal to the complexity of the initializer.
    public var wrappedValue: Value {
        mutating get {
            switch self {
            case .hasValue(let value, _):
                return value
                
            case .unset(let initializer):
                let value = initializer()
                self = .hasValue(value, initializer)
                return value
            }
        }
        set {
            self = .hasValue(newValue, { newValue })
        }
    }
}



// MARK: - Lazy

/// A non-resettable lazy pattern, to guarantee lazy behavior across language versions
@propertyWrapper
public struct Lazy<Value>: LazyContainer {
    
    /// Holds the internal value of this `Lazy`
    @LazyContainerValueReference
    @LazyContainerValueHolder
    public var wrappedValue: Value
    
    
    /// Creates a non-resettable lazy with the given value initializer. That closure will be called the very first time
    /// a value is needed:
    ///
    ///   1. The first time `value` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `value` will return the cached value
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        _wrappedValue = .init(wrappedValue: .unset(initializer))
    }
    
    
    /// Same as `init(initializer:)`
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
    /// - Parameter initialValue: The value to immediately store in `Lazy` container
    public init(initialValue: Value) {
        _wrappedValue = .init(wrappedValue: .hasValue(initialValue))
    }
    
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls are guaranteed to return the cached value from the first
    /// call.
    public var value: Value { wrappedValue }
}



// MARK: Resettable lazy

/// A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when
/// no longer needed.
///
/// - Attention: Because of the extra logic and memory required for this behavior, it's recommended that you use `Lazy`
///              instead wherever possible.
@propertyWrapper
public struct ResettableLazy<Value>: LazyContainer {
    
    /// Holds the internal value of this `ResettableLazy`
    @LazyContainerValueReference
    @LazyContainerResettableValueHolder
    public var wrappedValue: Value
    
    
    /// Creates a resettable lazy pattern with the given value initializer. That closure will be called every time a
    /// value is needed:
    ///
    ///   1. The first time `value` is called, the result from `initializer` will be cached and returned
    ///   2. Subsequent calls to get `value` will return the cached value
    ///   3. If `clear()` is called, the state is set back to step 1
    ///
    /// - Parameter initializer: The closure that will be called every time a value is needed
    public init(initializer: @escaping Initializer<Value>) {
        _wrappedValue = .init(wrappedValue: .unset(initializer))
    }
    
    
    /// Same as `init(initializer:)`
    ///
    /// - Parameter initializer: The closure that will be called the very first time a value is needed
    public init(wrappedValue initializer: @autoclosure @escaping Initializer<Value>) {
        self.init(initializer: initializer)
    }
    
    
    /// Creates a `ResettableLazy` that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a
    /// `ResettableLazy`), but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in `Lazy` container
    public init(initialValue: Value) {
        self.init(wrappedValue: initialValue)
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
        get { wrappedValue }
        set { wrappedValue = newValue }
    }
    
    
    /// Resets this lazy structure back to its unset state. Next time a value is needed, it will be regenerated using
    /// the initializer given by the constructor
    public mutating func clear() {
        _wrappedValue = .init(wrappedValue: .unset(_wrappedValue.wrappedValue.initializer))
    }
}



// MARK: - Functional lazy

/// An idea about how to approach the lazy pattern by using functions instead of branches.
///
/// - Attention: This is theoretically thread-safe, but hasn't undergone rigorous testing. The other two lazy patterns
///              in this file are `structs`, which means their value-passed nature gives them natural thread-safety,
///              whereas this is a `class`, which makes its reference-passed nature exposes it to possible
///              thread-unsafety. A short-lived semaphore was added to mitigate this, but again, it hasn't undergone
///              rigorous testing.
@propertyWrapper
public final class FunctionalLazy<Value>: LazyContainer {
    
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
    
    
    public init(wrappedValue initialValue: Value) {
        self.valueHolder = { initialValue }
    }
    
    
    public required convenience init(initialValue: Value) {
        self.init(wrappedValue: initialValue)
    }
    
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls return the cached value from the first call.
    public var wrappedValue: Value {
        return valueHolder()
    }
    
    
    public var value: Value { wrappedValue }
}
