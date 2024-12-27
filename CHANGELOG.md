#  6.0.0

This release follows 4.1.0. It's named 6.x for the following reasons:

- This major change brings full Swift 6 support to this library, so numbering it 6.x makes that more apparent
- Skipping version 5 opens the door for future compatibility releases in case someone requires a version that's more like 4.x, but incompatible-enough with 4.x that it earns different major version



## 2024-12-26

Initial movement from 4.x.

- Replaced confusing branching license with The Fair Licence
    - 4.x shipped with a branching license, where [the default license was BH-1-PS](https://github.com/RougeWare/Swift-Lazy-Containers/blob/4.1.0/LICENSE-GENERAL.txt), but some entities gained the [special privilege of using it under MIT](https://github.com/RougeWare/Swift-Lazy-Containers/blob/4.1.0/LICENSE-SPECIAL.txt). Those companies were [listed in the LICENSE.txt file](https://github.com/RougeWare/Swift-Lazy-Containers/blob/4.1.0/LICENSE.txt), meaning that only they could use the more-permissive license, and every else must use the more-restrictive license.
    - 5.x replaces all 3 of these license files with 1 extremely-permissive license: The Fair License.

- Removed dynamic products
    - These were added for a spcific developer's transitionary needs. That developer no longer has those needs, so these products are removed in favor of only producing static libraries.

- Renaming shipped module from `LazyContainers` to simply `Lazy`
    - This change reflects the goals of this library chaning. Instead of positioning itself as a series of container-types with lazy effects, it's the library you go to when you need lazy loading behavior.
    - This should also help with SEO and intuition. `import Lazy` makes more sense when you want to import lazy behavior, compared to `import LazyContainers`
    - 6.x will still ship a product named `LazyContainers` for transitionary purposes, but it's deprecated and discoruaged. The `LazyContainers` product will be exactly the same as `Lazy` until it is removed in a future version.

- Renaming the `LazyContainer` protocol to `LazyProtocol`
    - Included a migration-assistant typealias to facilitate the transition

- Full migration to Swift Package Manager
    - It's now clear that SPM is the best way to distribute & use Swift packages, so this update removes CocoaPods support and no longer considers any other way of importing this package.

- Split each `Lazy` structure to its own file
    - This should have been done long ago. It's a relic of the origin of this package as a single-file Gist for a StackOverflow answer. Original versions of this would encourage developers to include this repository entirely and reference the file directly. Now that this package is SPM-only, all reliance on older forms of distribution are discarded

- Some aliases which were previously marked as `deprecated` for this package's past transitions, are now marked as `unavailable`.
    - Their signatures remain the same, for those who are still using the old signature to get an error where these need to be replaced with the new ones.
    - Their content/behavior remain the same, in case any workflows consume a precompiled binary and then link to it.
    - Future versions will remove these old migration-only compatibilities entirely.

- Removed `@available(introduced:)` annotations
    - This package requires Swift 6, and so any API with a minimum-version requirement older than Swift 6, have had such requirements removed since they're redundant with the whole package's minimum-version requirement  

- `LazyContainerValueReference` was marked as `final`
    - This doesn't technically change anything, since exported `class`es which aren't marked `open` are implicitly closed to subclassing by external modules. This change makes the intent explicit & clear: `LazyContainerValueReference` was never intended to be subclassed, so marking it as `final` simply aligns its signature with the intent of the package creators, ensuring that developers don't misunderstand the package's intent.

- Transitioned to Swift Testing
    - Removed `LinuxMain.swift` & `XCTestManifests.swift` from tests since they're no longer needed

- Introduced `.initializeNow()`
    - https://github.com/RougeWare/Swift-Lazy-Containers/issues/40
