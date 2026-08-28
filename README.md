# Bifunctor

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Categorical bifunctor structure for Swift — the distributivity isomorphism between the binary product (`Pair`) and the binary coproduct (`Either`).

---

## Quick Start

When one arm of a product is itself a choice, you often want to push the choice outward: turn "a value **and** (this **or** that)" into "(value **and** this) **or** (value **and** that)". That is exactly the algebraic identity `A × (B + C) ≅ (A × B) + (A × C)`. This package realizes both directions of the iso for `Pair` (binary product) and `Either` (binary coproduct), so the two encodings convert losslessly into each other.

```swift
import Bifunctor

// Forward — distribute: Pair<A, Either<B, C>>  →  Either<Pair<A, B>, Pair<A, C>>
let pair: Pair<Int, Either<String, Bool>> = Pair(42, .left("hello"))
let distributed = Bifunctor.Distributivity.distribute(pair)
// .left(Pair(42, "hello"))

// Inverse — factor: Either<Pair<A, B>, Pair<A, C>>  →  Pair<A, Either<B, C>>
let either: Either<Pair<Int, String>, Pair<Int, Bool>> = .left(Pair(42, "hello"))
let factored = Bifunctor.Distributivity.factor(either)
// Pair(42, .left("hello"))
```

The law applies on either arm of the product, so each direction ships two overloads — discriminated by which `Pair`-arm holds the `Either`:

| Direction | Signature |
|-----------|-----------|
| `distribute` (`Either` in the second arm) | `Pair<A, Either<B, C>>` → `Either<Pair<A, B>, Pair<A, C>>` |
| `distribute` (`Either` in the first arm) | `Pair<Either<A, B>, C>` → `Either<Pair<A, C>, Pair<B, C>>` |
| `factor` (inverse of the first) | `Either<Pair<A, B>, Pair<A, C>>` → `Pair<A, Either<B, C>>` |
| `factor` (inverse of the second) | `Either<Pair<A, C>, Pair<B, C>>` → `Pair<Either<A, B>, C>` |

All four operate over `~Copyable & ~Escapable` arms: each value flows through exactly one branch of the match, so no value is duplicated and move-only types are admitted throughout.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-bifunctor.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Bifunctor", package: "swift-bifunctor"),
    ]
)
```

Requires Swift 6.4 and macOS 27 / iOS 27 / tvOS 27 / watchOS 27 / visionOS 27 (or the matching Linux / Windows toolchain).

---

## Architecture

Two library products. Depends only on the `Pair` and `Either` type-constructor atoms at `swift-atoms/swift-pair` and `swift-atoms/swift-either`.

| Product | Target | Purpose |
|---------|--------|---------|
| `Bifunctor` | `Sources/Bifunctor/` | The `Bifunctor` namespace and `Bifunctor.Distributivity`: the distributivity iso `A × (B + C) ≅ (A × B) + (A × C)` for `Pair × Either`, in both directions (`distribute` and `factor`). Re-exports `Pair` and `Either`. |
| `Bifunctor Test Support` | `Tests/Support/` | Re-exports the main target for test consumers. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 27 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
