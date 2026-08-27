# Interval

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The descriptor vocabulary for an interval's endpoints — which end (`Interval.Bound`), whether the endpoint is included (`Interval.Boundary`), and where a sequence terminates (`Interval.Endpoint`) — as three small, Foundation-free value types.

---

## Quick Start

`Interval` is a namespace of descriptors that specify *where* an interval begins and ends and *how* its endpoints behave. It holds the labels only — there is no `Interval` value type here, no comparison, no arithmetic — so the same vocabulary travels unchanged from the package that constructs ranges through every layer that interprets them.

Each descriptor is a two-case enum forming a Z₂ group: every value has a single opposite, reachable by `.opposite` or the prefix `!` operator.

```swift
import Interval

// Which end of the interval is this value?
let end: Interval.Bound = .upper
print(end.opposite)        // lower
print(!end)                // lower

// Is the endpoint included in the interval?
let boundary: Interval.Boundary = .closed
print(boundary.isInclusive)   // true
print(boundary.toggled)       // open

// Where does the sequence terminate?
let position: Interval.Endpoint = .start
print(position.opposite)   // end
```

Each descriptor reads in the vocabulary of its caller. `Interval.Bound` aliases `.lower`/`.upper` as `.min`/`.max` and `.left`/`.right`; `Interval.Endpoint` aliases `.start`/`.end` as `.first`/`.last` and `.head`/`.tail`. The underlying case is one value, so a `.min` produced in one module compares equal to a `.lower` consumed in another.

To carry a payload alongside a descriptor, the `Interval Pair` product of the companion `swift-interval-pair` package pairs a descriptor with a payload via each type's `Value<Payload>` typealias.

All three descriptors are `Sendable`, `Hashable`, `CaseIterable`, and (outside Embedded) `Codable`.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-molecules/swift-interval.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Interval", package: "swift-interval"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

The `Interval` target owns the whole descriptor vocabulary and has zero dependencies. Standard-library conformances beyond the core live in `Interval Standard Library Integration`; `Interval Apple Foundation Integration` is the only module that may import Foundation. Integration with `Pair` lives in the separate `swift-interval-pair` package.

| Product | Target | Purpose |
|---------|--------|---------|
| `Interval` | `Sources/Interval/` | The `Interval` namespace and the `Bound`, `Boundary`, and `Endpoint` descriptors. Zero dependencies. |
| `Interval Standard Library Integration` | `Sources/Interval Standard Library Integration/` | `Codable` conformances for the three descriptors. |
| `Interval Apple Foundation Integration` | `Sources/Interval Apple Foundation Integration/` | Foundation-facing surface; the only module allowed to import Foundation. |

Foundation-free.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
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
