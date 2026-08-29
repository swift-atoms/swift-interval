# Interval

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

The descriptor vocabulary for an interval's endpoints — which end (`Interval.Bound`), whether the endpoint is included (`Interval.Boundary`), and where a sequence terminates (`Interval.Endpoint`) — as three small, Foundation-free value types.

---

## Quick Start

`Interval` is a namespace of descriptors that specify *where* an interval begins and ends and *how* its endpoints behave. It holds the labels only — there is no `Interval` value type here, no comparison, no arithmetic — so the same vocabulary travels unchanged from the package that constructs ranges through every layer that interprets them.

Each descriptor is a two-case enum forming a Z₂ group: every value has a single opposite, reachable by `.opposite` or the prefix `!` operator.

```swift
import Interval_Bound
import Interval_Boundary
import Interval_Endpoint

// Which end of the interval is this value?
let end: Interval::Interval.Bound = .upper
print(end.opposite)        // lower
print(!end)                // lower

// Is the endpoint included in the interval?
let boundary: Interval::Interval.Boundary = .closed
print(boundary.isInclusive)   // true
print(boundary.toggled)       // open

// Where does the sequence terminate?
let position: Interval::Interval.Endpoint = .start
print(position.opposite)   // end
```

Each descriptor reads in the vocabulary of its caller. `Interval.Bound` aliases `.lower`/`.upper` as `.min`/`.max` and `.left`/`.right`; `Interval.Endpoint` aliases `.start`/`.end` as `.first`/`.last` and `.head`/`.tail`. The underlying case is one value, so a `.min` produced in one module compares equal to a `.lower` consumed in another.

To carry a payload alongside a descriptor, each type exposes a `Value<Payload>` typealias — a `Pair` of the descriptor and the payload:

```swift
import Interval_Bound
import Pair

// Tag a number with the bound it represents.
let labelled: Interval::Interval.Bound.Value<Int> = Pair(.lower, 0)
print(labelled.first, labelled.second)   // lower 0
```

All three descriptors are `Sendable`, `Hashable`, `CaseIterable`, and (outside Embedded) `Codable`.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-atoms/swift-interval.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Interval Bound", package: "swift-interval"),
        .product(name: "Interval Boundary", package: "swift-interval"),
        .product(name: "Interval Endpoint", package: "swift-interval"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

The `Interval` target is the dependency-free namespace root; each descriptor lives in its own layered target so a consumer imports only what it uses. The `Value<Payload>` typealiases depend on `Pair`.

| Product | Target | Purpose |
|---------|--------|---------|
| `Interval` | `Sources/Interval/` | The `Interval` namespace root. Zero external dependencies. |
| `Interval Bound` | `Sources/Interval Bound/` | `Interval.Bound` — lower/upper endpoint position, with `.opposite`, aliases (`min`/`max`, `left`/`right`), and `Value<Payload>`. |
| `Interval Boundary` | `Sources/Interval Boundary/` | `Interval.Boundary` — closed/open inclusivity, with `isInclusive`/`isExclusive`, `toggled`, and `Value<Payload>`. |
| `Interval Endpoint` | `Sources/Interval Endpoint/` | `Interval.Endpoint` — start/end sequence position, with `.opposite`, aliases (`first`/`last`, `head`/`tail`), and `Value<Payload>`. |
| `Interval Unit` | `Sources/Interval Unit/` | `Interval.Unit<Scalar>` — a scalar confined to `[0, 1]`, with checked/clamping initialization, complement, interpolation, multiplication, and the `Opacity` / `Alpha` aliases. |

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
