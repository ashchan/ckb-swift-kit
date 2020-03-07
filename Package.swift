// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CKB",
    products: [
        .library(
            name: "CKB",
            targets: ["CKB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.4"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.3.0"),
        .package(url: "https://github.com/jedisct1/swift-sodium.git", from: "0.8.0"),
    ],
    targets: [
        .target(
            name: "CKB",
            dependencies: [
                "CryptoSwift",
                "secp256k1",
                "Sodium"
            ],
            path: "./Source"
        ),
        .testTarget(
            name: "CKBTests",
            dependencies: ["CKB"],
            path: "./Tests"
        ),
    ]
)
