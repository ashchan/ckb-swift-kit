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
        .package(name: "ckb-blake2b", url: "https://github.com/ashchan/ckb-swift-blake2b.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "CKBFoundation",
            dependencies: [
                "secp256k1",
                "ckb-blake2b",
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
