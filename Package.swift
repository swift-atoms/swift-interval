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
            name: "Interval Primitive",
            targets: ["Interval Primitive"]
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
            name: "Interval",
            targets: ["Interval"]
        ),

        .library(
            name: "Interval Test Support",
            targets: ["Interval Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-pair.git",
            branch: "main"
        )
    ],
    targets: [

        .target(
            name: "Interval Primitive",
            dependencies: []
        ),

        .target(
            name: "Interval Bound",
            dependencies: [
                "Interval Primitive",
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Interval Boundary",
            dependencies: [
                "Interval Primitive",
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),
        .target(
            name: "Interval Endpoint",
            dependencies: [
                "Interval Primitive",
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),

        .target(
            name: "Interval",
            dependencies: [
                "Interval Primitive",
                "Interval Bound",
                "Interval Boundary",
                "Interval Endpoint",
                .product(name: "Pair", package: "swift-pair"),
            ]
        ),

        .target(
            name: "Interval Test Support",
            dependencies: [
                "Interval"
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Interval Tests",
            dependencies: [
                "Interval",
                "Interval Test Support",
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
