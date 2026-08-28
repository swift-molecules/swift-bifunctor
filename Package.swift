// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-bifunctor",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "Bifunctor",
            targets: ["Bifunctor"]
        ),
        .library(
            name: "Bifunctor Test Support",
            targets: ["Bifunctor Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-pair.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-either.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-pair-equation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-either-equation.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "Bifunctor",
            dependencies: [
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Either", package: "swift-either"),
            ]
        ),
        .target(
            name: "Bifunctor Test Support",
            dependencies: [
                "Bifunctor"
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Bifunctor Tests",
            dependencies: [
                "Bifunctor",
                "Bifunctor Test Support",
                .product(name: "Pair", package: "swift-pair"),
                .product(name: "Either", package: "swift-either"),
                .product(name: "Pair Equation", package: "swift-pair-equation"),
                .product(name: "Either Equation", package: "swift-either-equation"),
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
