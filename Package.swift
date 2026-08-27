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
            name: "Interval Standard Library Integration",
            targets: ["Interval Standard Library Integration"]
        ),
        .library(
            name: "Interval Apple Foundation Integration",
            targets: ["Interval Apple Foundation Integration"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Interval",
            dependencies: []
        ),
        .target(
            name: "Interval Standard Library Integration",
            dependencies: ["Interval"]
        ),
        .target(
            name: "Interval Apple Foundation Integration",
            dependencies: [
                "Interval",
                "Interval Standard Library Integration",
            ]
        ),
        .testTarget(
            name: "Interval Tests",
            dependencies: ["Interval"]
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
