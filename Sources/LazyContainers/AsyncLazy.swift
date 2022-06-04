//
//  AsyncLazy.swift
//  
//
//  Created by S🌟System on 2022-06-03.
//

import Foundation



/// Asynchronous form of `Lazy`. 
@available(macOS 10.15, *)
@propertyWrapper
public struct AsyncLazy<Value> {
    private var guts: Guts
    
    
    public var wrappedValue: Value {
        get { guts.wrappedValue }
        set { guts.wrappedValue = newValue }
    }
}



// MARK: - LazyContainer

public extension AsyncLazy: LazyContainer {
    public var isInitialized: Bool
    
    public static func preinitialized(_ initialValue: Value) -> Self {
        <#code#>
    }
    
    
    
}



// MARK: - Private API

@available(macOS 10.15, *)
private extension AsyncLazy {
    
}
