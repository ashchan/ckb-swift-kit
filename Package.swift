// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "CKB",
    products: [
        .library(
            name: "CKB",
            targets: ["CKB"]),
    ],
    dependencies: [
        .package(name: "secp256k1", url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.4"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.3.0"),
        .package(name: "Sodium", url: "https://github.com/jedisct1/swift-sodium.git", from: "0.8.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.1.0"),
    ],
    targets: [
        .target(
            name: "CKB",
            dependencies: [
                "secp256k1",
                "CryptoSwift",
                "Sodium",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
            ],
            path: "./Sources"
        ),
        .testTarget(
            name: "CKBTests",
            dependencies: ["CKB"],
            path: "./Tests"
        ),
    ]
)
