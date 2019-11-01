//
//  WitnessArgsSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class WitnessArgsTests: XCTestCase {
    func testOptionValueSerialization() {
        XCTAssertEqual(
            [16, 0, 0, 0, 16, 0, 0, 0, 16, 0, 0, 0, 16, 0, 0, 0],
            WitnessArgs.parsed("0x", "0x", "0x").serialize()
        )
    }

    func testEmptyLock() {
        XCTAssertEqual(
            [85, 0, 0, 0, 16, 0, 0, 0, 85, 0, 0, 0, 85, 0, 0, 0, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            WitnessArgs.emptyLock.serialize()
        )
    }
}
