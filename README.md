# Swift Lazy Patterns
A few lazy patterns for Swift 4. Note that, if you are OK with the behavior of Swift's `lazy` keyword, you should use that. This is for [those who want very specific behaviors](https://stackoverflow.com/a/40847994/3939277):

 * [`Lazy`](https://github.com/BenLeggiero/Swift-Lazy-Patterns/blob/master/Lazy.swift#L31-L84): A non-resettable lazy pattern, to guarantee lazy behavior across Swift language versions
 * [`ResettableLazy`](https://github.com/BenLeggiero/Swift-Lazy-Patterns/blob/master/Lazy.swift#L88-L171): A resettable lazy pattern, whose value is generated and cached only when first needed, and can be destroyed when no longer needed.
 * [`FunctionalLazy`](https://github.com/BenLeggiero/Swift-Lazy-Patterns/blob/master/Lazy.swift#L175-L225): An idea about how to approach the lazy pattern by using functions instead of branches.
 
