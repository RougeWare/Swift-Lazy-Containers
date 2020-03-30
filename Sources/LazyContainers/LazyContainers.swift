//
//  Lazy.swift
//  Lazy in Swift 5.1
//
//  Created by Ben Leggiero on 2018-05-04.
//  Version 3.0.0 (last edited 2019-08-30)
//  Copyright BH-0-PD © 2019 - https://github.com/BlueHuskyStudios/Licenses/blob/master/Licenses/BH-0-PD.txt
//

import Foundation



// MARK: - Supporting types

/// Simply initializes a value
public typealias Initializer<Value> = () -> Value



/// Defines how a lazy container should look
public protocol LazyContainer {
    
    /// The type of the value that will be lazily-initialized
    associatedtype Value
    
    /// Gets the value, possibly initializing it first
    var wrappedValue: Value {
        get
        mutating set // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
    
    
    /// Indicates whether the value has indeed been initialized
    var isInitialized: Bool { get }
    
    
    /// Creates a lazy container that already contains an initialized value.
    ///
    /// This is useful when you need a uniform API (for instance, when implementing a protocol that requires a `Lazy`),
    /// but require it to already hold a value up-front
    ///
    /// - Parameter initialValue: The value to immediately store in the otherwise-lazy container
    static func preinitialized(_ initialValue: Value) -> Self
}



public extension LazyContainer {
    /// Allows you to use reference semantics to hold a value inside a lazy container
    typealias ValueReference = LazyContainerValueReference
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    typealias ValueHolder = LazyContainerValueHolder
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    typealias ResettableValueHolder = LazyContainerResettableValueHolder
}



/// Allows you to use reference-semantics to hold a value inside a lazy container
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
}



/// Takes care of keeping track of the state, value, and initializer of a resettable lazy container, as needed
@propertyWrapper
public enum LazyContainerResettableValueHolder<Value> {
    
    /// Indicates that a value has been cached, and contains that cached value, and the initializer in case the
    /// value is cleared again later on
    case hasValue(value: Value, initializer: Initializer<Value>)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(initializer: Initializer<Value>)
    
    /// Finds and returns the initializer held within this enum case
    var initializer: Initializer<Value> {
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



// MARK: - Lazy

/// A non-resettable lazy container, to guarantee lazy behavior across language versions
///
/// - Attention: Because of the extra logic and memory required for this behavior, it's recommended that you use the
///              language's built-in `lazy` instead wherever possible.
@propertyWrapper
@dynamicMemberLookup
public struct Lazy<Value>: LazyContainer {
    
    /// Privatizes the inner-workings of this functional lazy container
    @LazyContainerValueReference
    private var guts: LazyContainerValueHolder<Value>
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: LazyContainerValueReference<LazyContainerValueHolder<Value>>) {
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
    
    
    // MARK: @dynamicMemberLookup
    
    public subscript<Subject>(dynamicMember keyPath: KeyPath<Value, Subject>) -> Subject {
        wrappedValue[keyPath: keyPath]
    }
    
    
    public subscript<Subject>(dynamicMember keyPath: WritableKeyPath<Value, Subject>) -> Subject {
        get {
            wrappedValue[keyPath: keyPath]
        }
        mutating set {
            wrappedValue[keyPath: keyPath] = newValue
        }
    }
    
    
    public subscript<Subject>(dynamicMember keyPath: ReferenceWritableKeyPath<Value, Subject>) -> Subject {
        get {
            wrappedValue[keyPath: keyPath]
        }
        nonmutating set {
            wrappedValue[keyPath: keyPath] = newValue
        }
    }
}



// MARK: Resettable lazy

/// A resettable lazy container, whose value is generated and cached only when first needed, and can be destroyed when
/// no longer needed.
///
/// - Attention: Because of the extra logic and memory required for this behavior, it's recommended that you use `Lazy`
///              or the language's built-in `lazy` instead wherever possible.
@propertyWrapper
public struct ResettableLazy<Value>: LazyContainer {
    
    /// Privatizes the inner-workings of this functional lazy container
    @LazyContainerValueReference
    private var guts: LazyContainerResettableValueHolder<Value>
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: LazyContainerValueReference<LazyContainerResettableValueHolder<Value>>) {
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



// MARK: - Functional lazy

/// An idea about how to approach the lazy container by using functions instead of branches.
///
/// - Attention: This is theoretically thread-safe, but hasn't undergone rigorous real-world testing. A short-lived
///              semaphore was added to mitigate this, but again, it hasn't undergone rigorous real-world testing.
@propertyWrapper
public struct FunctionalLazy<Value>: LazyContainer {
    
    /// Privatizes the inner-workings of this functional lazy container
    @Guts
    private var guts: Value
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: Guts<Value>) {
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
    
    
    
    /// The actual functionality of `FunctionalLazy`, separated so that the semantics work out better
    @propertyWrapper
    private final class Guts<Value> {
        
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
        

        /// Indicates whether the value has indeed been initialized
        public var isInitialized: Bool { nil == semaphore }
    }
}



// MARK: - Migration Assistant



/// The name which was used for `LazyContainer` in version `1.x` of this API. Included for transition smoothness.
@available(*, deprecated, renamed: "LazyContainer")
public typealias LazyPattern = LazyContainer



public extension Lazy {
    
    /// Returns the value held within this struct.
    /// If there is none, it is created using the initializer given when this struct was initialized. This process only
    /// happens on the first call to `value`; subsequent calls are guaranteed to return the cached value from the first
    /// call.
    @available(*, deprecated, renamed: "wrappedValue",
    message: """
             `Lazy` is now a Swift 5.1 property wrapper, which requires a `wrappedValue` field.
             Since these behave identically, you should use the newer `wrappedValue` field instead.
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
             `ResettableLazy` is now a Swift 5.1 property wrapper, which requires a `wrappedValue` field.
             Since these behave identically, you should use the newer `wrappedValue` field instead.
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
             `FunctionalLazy` is now a Swift 5.1 property wrapper, which requires a `wrappedValue` field.
             Since these behave identically, you should use the newer `wrappedValue` field instead.
             """
    )
    var value: Value {
        get { wrappedValue }
        mutating set { wrappedValue = newValue } // If you feel like you want this to be nonmutating, see https://GitHub.com/RougeWare/Swift-Safe-Pointer
    }
}
