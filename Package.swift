// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "ckb-swift-kit",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
    ],
    products: [
        .library(name: "CKBKit", targets: ["CKBKit"]),
        .library(name: "CKBFoundation", targets: ["CKBKit"]),
    ],
    dependencies: [
        .package(name: "secp256k1", url: "https://github.com/ashchan/secp256k1.swift.git", .revision("fcc26596f57bd354dd8ff3e19b2ce3cf58992ee6")),
        .package(name: "ckb-blake2b", url: "https://github.com/ashchan/ckb-swift-blake2b.git", from: "0.1.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMinor(from: "1.3.1")),
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
            dependencies: [
                "CKBFoundation",
                "CryptoSwift",
            ]
        ),
        .testTarget(
            name: "CKBKitTests",
            dependencies: ["CKBKit"],
            path: "./Tests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
