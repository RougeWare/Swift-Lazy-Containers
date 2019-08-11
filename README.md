[![CodeFactor](https://www.codefactor.io/repository/github/rougeware/swift-lazy-patterns/badge)](https://www.codefactor.io/repository/github/rougeware/swift-lazy-patterns)

# Swift Lazy Containers #
A few ways to have a lazily-initialized value in Swift 5.1. Note that, if you are OK with the behavior of Swift's `lazy` keyword, you should use that. This is for [those who want very specific behaviors](https://stackoverflow.com/a/40847994/3939277):

 * [`Lazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Lazy.swift#L184-L248): A non-resettable lazy pattern, to guarantee lazy behavior across Swift language versions
 * [`ResettableLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Lazy.swift#L252-L330): A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when no longer needed.
 * [`FunctionalLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/Lazy.swift#L334-L444): An idea about how to approach the lazy pattern by using functions instead of branches.


# Compatibility Notice #

The API had notable changes when transitioning from 1.1.0 to 2.0.0. To ease this transition, `Lazy.swift` was left in the root of this repo.

Additionally, to make this a Swift Package, both `Lazy.swift` and its tests were duplicated.

In version 3.0.0, `Lazy.swift` will be moved to `LazyContainers/Sources/LazyContainers/LazyContainers.swift` in order to reduce this duplication. To ease that transition, you should change any hard-coded references to `Lazy.swift` to point to `LazyContainers/Sources/LazyContainers/LazyContainers.swift`. 
