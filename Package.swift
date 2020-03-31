// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "ckb-swift-kit",
    products: [
        .library(name: "CKBKit", targets: ["CKBKit"]),
        .library(name: "CKBFoundation", targets: ["CKBKit"]),
    ],
    dependencies: [
        .package(name: "secp256k1", url: "https://github.com/ashchan/secp256k1.swift.git", .branch("master")),
        .package(name: "Sodium", url: "https://github.com/jedisct1/swift-sodium.git", from: "0.8.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "CKBFoundation",
            dependencies: [
                "secp256k1",
                "CryptoSwift",
                "Sodium",
            ]
        ),
        .target(
            name: "CKBKit",
            dependencies: ["CKBFoundation"]
        ),
        .testTarget(
            name: "CKBKitTests",
            dependencies: ["CKBKit"],
            path: "./Tests"
        ),
    ]
)
