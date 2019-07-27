//
//  Blake2bTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class Blake2bTests: XCTestCase {
    let fixtures = [
        ["", "44f4c69744d5f8c55d642062949dcae49bc4e7ef43d388c5a12f42b5633d163e"],
        ["The quick brown fox jumps over the lazy dog", "abfa2c08d62f6f567d088d6ba41d3bbbb9a45c241a8e3789ef39700060b5cee2"]
    ]

    func testHashData() {
        fixtures.forEach { testcase in
            let blake2b = Blake2b()
            let hashed =  blake2b.hash(data: testcase.first!.data(using: .utf8)!)!.toHexString()
            XCTAssertEqual(testcase.last!, hashed)
        }
    }

    func testHashBytes() {
        fixtures.forEach { testcase in
            let blake2b = Blake2b()
            let hashed =  blake2b.hash(bytes: testcase.first!.data(using: .utf8)!.bytes)!.toHexString()
            XCTAssertEqual(testcase.last!, hashed)
        }
    }
}
