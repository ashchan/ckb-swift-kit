//
//  Blake2bTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/03/06.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class Blake2bTests: XCTestCase {
    let fixtures = [
        ["", "0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8"],
        ["The quick brown fox jumps over the lazy dog", "01718cec35cd3d796dd00020e0bfecb473ad23457d063b75eff29c0ffa2e58a9"]
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
