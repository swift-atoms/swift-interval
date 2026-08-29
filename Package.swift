// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-interval",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(
            name: "Interval",
            targets: ["Interval"]
        ),

        .library(
            name: "Interval Bound",
            targets: ["Interval Bound"]
        ),
        .library(
            name: "Interval Boundary",
            targets: ["Interval Boundary"]
        ),
        .library(
            name: "Interval Endpoint",
            targets: ["Interval Endpoint"]
        ),
        .library(
            name: "Interval Unit",
            targets: ["Interval Unit"]
        ),

    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        )
    ],
    targets: [

        .target(
            name: "Interval",
            dependencies: []
        ),

        .target(
            name: "Interval Bound",
            dependencies: [
                .target(name: "Interval"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Interval Boundary",
            dependencies: [
                .target(name: "Interval"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Interval Endpoint",
            dependencies: [
                .target(name: "Interval"),
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Interval Unit",
            dependencies: [
                .target(name: "Interval"),
            ]
        ),

        .testTarget(
            name: "Interval Tests",
            dependencies: [
                .target(name: "Interval"),
            ]
        ),
        .testTarget(
            name: "Interval Bound Tests",
            dependencies: [
                .target(name: "Interval Bound"),
            ]
        ),
        .testTarget(
            name: "Interval Boundary Tests",
            dependencies: [
                .target(name: "Interval Boundary"),
            ]
        ),
        .testTarget(
            name: "Interval Endpoint Tests",
            dependencies: [
                .target(name: "Interval Endpoint"),
            ]
        ),
        .testTarget(
            name: "Interval Unit Tests",
            dependencies: [
                .target(name: "Interval Unit"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
