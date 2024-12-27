//
//  AsyncLazy.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



//@propertyWrapper // Property wrappers currently cannot define an 'async' or 'throws' accessor
public struct AsyncLazy<Value: Sendable> {
    
    private var _guts: AsyncValueReference<AsyncValueHolder>
    
    
//    init(initializer: @escaping AsyncInitializer<Value>) {
//        self.init(_guts: .init(wrappedValue: .unset(initializer: initializer)))
//    }
    
    
    /// Allows other initializers to have a shared point of initialization
    private init(_guts: AsyncValueReference<AsyncValueHolder>) {
        self._guts = _guts
    }
    
    
    public nonisolated var wrappedValue: Value {
        get async { await _guts.wrappedValue.wrappedValue }
    }
}



extension AsyncLazy: AsyncLazyProtocol
where Value: Sendable
{
    public mutating func mutate(_ isolatedMutator: (inout Value) async -> Void) async {
        await _guts.mutate { asyncLazyContainerValueHolder in
            await asyncLazyContainerValueHolder.mutate { value in
                await isolatedMutator(&value)
            }
        }
    }
    
    public func get() async -> Value {
        await _guts.wrappedValue.wrappedValue
    }
    
    
    public nonisolated func set(to newValue: sending Value) async {
        await _guts.set(to: .hasValue(value: newValue))
    }
    
    
    public static func preinitialized(_ initialValue: Value) -> Self {
        Self.init(_guts: .init(wrappedValue: .hasValue(value: initialValue)))
    }
    
    
    public var isInitialized: Bool {
        get async { await _guts.wrappedValue.hasValue }
    }
    
    
    public func initializeNow() async {
        await _guts.mutate { wrappedValue in
            await wrappedValue.initializeNow()
        }
    }
}



// MARK: - ValueHolder

/// Takes care of keeping track of the state, value, and initializer of a lazy container, as needed
//@propertyWrapper // Property wrappers currently cannot define an 'async' or 'throws' accessor
public enum AsyncLazyContainerValueHolder<Value: Sendable>: Sendable {
    
    /// Indicates that a value has been cached, and contains that cached value
    case hasValue(value: Value)
    
    /// Indicates that the value has not yet been created, and contains its initializer
    case unset(initializer: AsyncInitializer<Value>)
    
    
    /// The value held inside this value holder.
    /// - Attention: Reading this value may mutate the state in order to compute the value. The complexity of that read
    ///              operation is equal to the complexity of the initializer.
    public var wrappedValue: Value {
        mutating get async {
            switch self {
            case .hasValue(let value):
                return value
                
            case .unset(let initializer):
                let value = await initializer()
                self = .hasValue(value: value)
                return value
            }
        }
    }
    
    
    /// Sets the value asynchronously
    public mutating func set(to newValue: Value) async {
        self = .hasValue(value: newValue)
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
    mutating func initializeNow() async {
        switch self {
        case .hasValue(_): return
        case .unset(let initializer):
            self = await .hasValue(value: initializer())
        }
    }
    
    
    mutating func mutate(_ isolatedMutator: (inout Value) async -> Void) async {
        var wrappedValue = await self.wrappedValue
        await isolatedMutator(&wrappedValue)
        await self.set(to: wrappedValue)
    }
}




public extension AnyLazy {
    
    /// Takes care of keeping track of the state, value, and initializer as needed
    typealias AsyncValueHolder = AsyncLazyContainerValueHolder<Value>
}

