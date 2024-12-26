[![Tested on GitHub Actions](https://github.com/RougeWare/swift-lazy-containers/actions/workflows/swift.yml/badge.svg)](https://github.com/RougeWare/swift-lazy-containers/actions/workflows/swift.yml) [![](https://www.codefactor.io/repository/github/rougeware/swift-lazy-containers/badge)](https://www.codefactor.io/repository/github/rougeware/swift-lazy-containers)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRougeWare%2FSwift-Lazy-Containers%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/RougeWare/Swift-Lazy-Containers) [![swift package manager 5.2 is supported](https://img.shields.io/badge/swift%20package%20manager-5.2-brightgreen.svg)](https://swift.org/package-manager) [![Supports macOS, iOS, tvOS, watchOS, Linux, & Windows](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FRougeWare%2FSwift-Lazy-Containers%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/RougeWare/Swift-Lazy-Containers) 
[![](https://img.shields.io/github/release-date/rougeware/swift-lazy-containers?label=latest%20release)](https://github.com/RougeWare/Swift-Lazy-Containers/releases/latest)



# Advanced [Lazy](https://github.com/RougeWare/Swift-Lazy-Containers) Behavior for Swift
A few ways to have a lazily-initialized value in Swift 6. 

**Important:** If you are OK with the behavior of Swift's `lazy` keyword, you should **use that**. This is for [those who want very specific behaviors](https://stackoverflow.com/a/40847994/3939277):

 * [`Lazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Sources/LazyContainers/LazyContainers.swift#L184-L248): A non-resettable lazy pattern, to guarantee lazy behavior across Swift language versions
 * [`ResettableLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Sources/LazyContainers/LazyContainers.swift#L252-L330): A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when no longer needed.
 * [`FunctionalLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Sources/LazyContainers/LazyContainers.swift#L334-L444): An idea about how to approach the lazy pattern by using functions instead of branches.



# Automatic Conformance #

The built-in containers (`Lazy`, `ResettableLazy`, and `FunctionalLazy`) automatically conform to `Equatable`, `Hashable`, `Encodable`, and `Decodable` when their values conform do too! This is a passthrough conformance, simply calling the functions of the wrapped value.

Keep in mind, though, that in order to do this, the value is automatically initialized and accessed! 



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



# Compatibility Notice #

Version 6 has notble compatibility changes, noted in [the changelog](./CHANGELOG.md), including:

- Changed the library name from `LazyContainers` to `Lazy`
- Removed CocoaPods support
- Removed support for direct-consumption of the `LazyContainers.swift` file
- Changed license to be as permissible as possible

For a full list of changes and reasoning/notes, see [CHANGELOG.md](./CHANGELOG.md)



## The old name is deprecated

If you are upgrading to version 6 of this package or newer, then you are encouraged to change all uses of `LazyContainers` to `Lazy`. In your package dependencies, Xcode project file, imports, etc.

`LazyContainers` is still provided to ease this, but will be removed in a future version.
