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
        .library(name: "Interval", targets: ["Interval"]),

        .library(name: "Interval Foundation Integration", targets: ["Interval Foundation Integration"]),
        .library(name: "Interval Test Support", targets: ["Interval Test Support"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-advancement.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-difference.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-distance.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Interval",
            dependencies: [
                .product(name: "Advancement", package: "swift-advancement"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Distance", package: "swift-distance"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Pair", package: "swift-pair"),
            ],
            path: "Sources/Interval"
        ),
        
        .target(
            name: "Interval Foundation Integration",
            dependencies: [
                .target(name: "Interval"),
            ],
            path: "Sources/Interval Foundation Integration"
        ),
        .target(
            name: "Interval Test Support",
            dependencies: [
                .target(name: "Interval"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Interval Tests",
            dependencies: [
                .target(name: "Interval"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Difference", package: "swift-difference"),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .target(name: "Interval Test Support"),
                .target(name: "Interval Foundation Integration"),
            ],
            path: "Tests/Interval Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
