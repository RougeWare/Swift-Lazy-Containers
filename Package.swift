// swift-tools-version:6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LazyContainers",
    
    products: [
        .library(
            name: "LazyContainers",
            targets: ["Lazy"]),
        .library(
            name: "Lazy",
            targets: ["Lazy"]),
    ],
    
    targets: [
        .target(
            name: "Lazy",
            dependencies: []),
        .testTarget(
            name: "LazyTests",
            dependencies: ["Lazy"]),
    ],
    
    swiftLanguageModes: [.v6]
)
