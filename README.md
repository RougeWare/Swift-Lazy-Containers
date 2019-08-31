[![CodeFactor](https://www.codefactor.io/repository/github/rougeware/swift-lazy-patterns/badge)](https://www.codefactor.io/repository/github/rougeware/swift-lazy-patterns)

# [Swift Lazy Containers](https://github.com/RougeWare/Swift-Lazy-Patterns) #
A few ways to have a lazily-initialized value in Swift 5.1. Note that, if you are OK with the behavior of Swift's `lazy` keyword, you should use that. This is for [those who want very specific behaviors](https://stackoverflow.com/a/40847994/3939277):

 * [`Lazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/LazyContainers.swift#L184-L248): A non-resettable lazy pattern, to guarantee lazy behavior across Swift language versions
 * [`ResettableLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/LazyContainers.swift#L252-L330): A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when no longer needed.
 * [`FunctionalLazy`](https://github.com/RougeWare/Swift-Lazy-Patterns/blob/master/LazyContainers.swift#L334-L444): An idea about how to approach the lazy pattern by using functions instead of branches.



# Compatibility Notice #

The entire repository structure had to be changed in order to be compatible with Swift Package Manager ([#4](https://github.com/RougeWare/Swift-Lazy-Patterns/issues/4)). Because of this, the API version changed from 2.0.0 to 3.0.0. Very little of the actual API changed along with this ([#8](https://github.com/RougeWare/Swift-Lazy-Patterns/issues/8)); it was almost entirely to service Swift Package manager.

In version 2.0.0, [this readme recommended](https://github.com/RougeWare/Swift-Lazy-Patterns/commit/68fd42023fe5642dd9841ea1411027f6cbc1032f#diff-04c6e90faac2675aa89e2176d2eec7d8) that you change any reference to `./Lazy.swift` to `./LazyContainers/Sources/LazyContainers/LazyContainers.swift`. Unfortunately, that wasn't compatible with Swift Package Manager, so `./Lazy.swift` was changed to `./Sources/LazyContainers/LazyContainers.swift`. Because of this, please change any reference to `./LazyContainers/Sources/LazyContainers/LazyContainers.swift` to `./Sources/LazyContainers/LazyContainers.swift`. Sorry about that 🤷🏽‍
