// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Oklch",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "Oklch", targets: ["Oklch"]),
    ],
    targets: [
        .target(name: "Oklch"),

    ]
)
