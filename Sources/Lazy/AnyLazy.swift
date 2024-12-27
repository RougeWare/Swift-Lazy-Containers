//
//  AnyLazy.swift
//  https://github.com/RougeWare/Swift-Lazy-Containers
//
//  Created by Ky on 2024-12-26.
//  Copyright waived. No rights reserved.
//

import Foundation



/// The protocol to which all lazy protocols & types conform
public protocol AnyLazy {
    
    /// The type of the value that will be lazily-initialized
    associatedtype Value
}
