[![Tested on GitHub Actions](https://github.com/RougeWare/swift-lazy-containers/actions/workflows/swift.yml/badge.svg)](https://github.com/RougeWare/swift-lazy-containers/actions/workflows/swift.yml) [![](https://www.codefactor.io/repository/github/rougeware/swift-lazy-containers/badge)](https://www.codefactor.io/repository/github/rougeware/swift-lazy-containers)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRougeWare%2FSwift-Lazy-Containers%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/RougeWare/Swift-Lazy-Containers) [![swift package manager 5.2 is supported](https://img.shields.io/badge/swift%20package%20manager-5.2-brightgreen.svg)](https://swift.org/package-manager) [![Supports macOS, iOS, tvOS, watchOS, Linux, & Windows](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRougeWare%2FSwift-Lazy-Containers%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/RougeWare/Swift-Lazy-Containers) 
[![](https://img.shields.io/github/release-date/rougeware/swift-lazy-containers?label=latest%20release)](https://github.com/RougeWare/Swift-Lazy-Containers/releases/latest)



# [Swift Lazy Containers](https://github.com/RougeWare/Swift-Lazy-Patterns) #
A few ways to have a lazily-initialized value in Swift 5.1. Note that, if you are OK with the behavior of Swift's `lazy` keyword, you should use that. This is for [those who want very specific behaviors](https://stackoverflow.com/a/40847994/3939277):

 * [`Lazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Sources/LazyContainers/LazyContainers.swift#L184-L248): A non-resettable lazy pattern, to guarantee lazy behavior across Swift language versions
 * [`ResettableLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Sources/LazyContainers/LazyContainers.swift#L252-L330): A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when no longer needed.
 * [`FunctionalLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Sources/LazyContainers/LazyContainers.swift#L334-L444): An idea about how to approach the lazy pattern by using functions instead of branches.



# Automatic Conformance #

The built-in containers (`Lazy`, `ResettableLazy`, and `FunctionalLazy`) automatically conform to `Equatable` and `Hashable` when their values conform do too!

Keep in mind, though, that in order to do this, the value is automatically initialized and accessed!



# Compatibility Notice #

The entire repository structure had to be changed in order to be compatible with Swift Package Manager ([#4](https://github.com/RougeWare/Swift-Lazy-Patterns/issues/4)). Because of this, the API version changed from 2.0.0 to 3.0.0. Very little of the actual API changed along with this ([#8](https://github.com/RougeWare/Swift-Lazy-Patterns/issues/8)); it was almost entirely to service Swift Package manager.

In version 2.0.0, [this readme recommended](https://github.com/RougeWare/Swift-Lazy-Patterns/commit/68fd42023fe5642dd9841ea1411027f6cbc1032f#diff-04c6e90faac2675aa89e2176d2eec7d8) that you change any reference to `./Lazy.swift` to `./LazyContainers/Sources/LazyContainers/LazyContainers.swift`. Unfortunately, that wasn't compatible with Swift Package Manager, so `./Lazy.swift` was changed to `./Sources/LazyContainers/LazyContainers.swift`. Because of this, please change any reference to `./LazyContainers/Sources/LazyContainers/LazyContainers.swift` to `./Sources/LazyContainers/LazyContainers.swift`. Sorry about that 🤷🏽‍



# Examples #

It's easy to use each of these. Simply place the appropriate one as a property wrapper where you want it.


## `Lazy` ##

The simple usage of this is very straightforward:

```swift

@Lazy
var myLazyString = "Hello, lazy!"

print(myLazyString) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString) // Just returns the value "Hello, lazy!"

myLazyString = "Overwritten"
print(myLazyString) // Just returns the value "Overwritten"
print(myLazyString) // Just returns the value "Overwritten"
```

This will print:

```plain
Hello, lazy!
Hello, lazy!
Overwritten
Overwritten
```

### More complex initializer ##

If you have complex initializer logic, you can pass that to the property wrapper:

```swift

func makeLazyString() -> String {
    print("Initializer side-effect")
    return "Hello, lazy!"
}

@Lazy(initializer: makeLazyString)
var myLazyString: String

print(myLazyString) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString) // Just returns the value "Hello, lazy!"

myLazyString = "Overwritten"
print(myLazyString) // Just returns the value "Overwritten"
print(myLazyString) // Just returns the value "Overwritten"
```

You can also use it directly (instaed of as a property wrapper):

```swift
var myLazyString = Lazy<String>() {
    print("Initializer side-effect")
    return "Hello, lazy!"
}

print(myLazyString.wrappedValue) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString.wrappedValue) // Just returns the value "Hello, lazy!"

myLazyString.wrappedValue = "Overwritten"
print(myLazyString.wrappedValue) // Just returns the value "Overwritten"
print(myLazyString.wrappedValue) // Just returns the value "Overwritten"
```

These will both print:

```plain
Initializer side-effect
Hello, lazy!
Hello, lazy!
Overwritten
Overwritten
```


## `ResettableLazy` ##

The simple usage of this is very straightforward:

```swift

@ResettableLazy
var myLazyString = "Hello, lazy!"

print(myLazyString) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString) // Just returns the value "Hello, lazy!"

_myLazyString.clear()
print(myLazyString) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString) // Just returns the value "Hello, lazy!"

myLazyString = "Overwritten"
print(myLazyString) // Just returns the value "Overwritten"
_myLazyString.clear()
print(myLazyString.wrappedValue) // Initializes, caches, and returns the value  "Hello, lazy!"
```

This will print:

```plain
Hello, lazy!
Hello, lazy!
Hello, lazy!
Hello, lazy!
Overwritten
Hello, lazy!
```

### More complex initializer ##

If you have complex initializer logic, you can pass that to the property wrapper:

```swift

func makeLazyString() -> String {
    print("Initializer side-effect")
    return "Hello, lazy!"
}

@ResettableLazy(initializer: makeLazyString)
var myLazyString: String

print(myLazyString) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString) // Just returns the value "Hello, lazy!"

_myLazyString.clear()
print(myLazyString) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString) // Just returns the value "Hello, lazy!"

myLazyString = "Overwritten"
print(myLazyString) // Just returns the value "Overwritten"
_myLazyString.clear()
print(myLazyString.wrappedValue) // Initializes, caches, and returns the value  "Hello, lazy!"
```

You can also use it directly (instaed of as a property wrapper):

```swift
var myLazyString = ResettableLazy<String>() {
    print("Initializer side-effect")
    return "Hello, lazy!"
}

print(myLazyString.wrappedValue) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString.wrappedValue) // Just returns the value "Hello, lazy!"

myLazyString.clear()
print(myLazyString.wrappedValue) // Initializes, caches, and returns the value "Hello, lazy!"
print(myLazyString.wrappedValue) // Just returns the value "Hello, lazy!"

myLazyString.wrappedValue = "Overwritten"
print(myLazyString.wrappedValue) // Just returns the value "Overwritten"
_myLazyString.clear()
print(myLazyString.wrappedValue) // Initializes, caches, and returns the value  "Hello, lazy!"
```

These will both print:

```plain
Initializer side-effect
Hello, lazy!
Hello, lazy!
Initializer side-effect
Hello, lazy!
Hello, lazy!
Overwritten
Initializer side-effect
Hello, lazy!
```



## `FunctionalLazy` ##

This is functionally <sub>(ha!)</sub> the same as `Lazy`. The only difference is I thought it'd be fun to implement it with functions instead of enums. 🤓
