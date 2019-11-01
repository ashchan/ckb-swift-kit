//
//  WitnessArgsSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class WitnessArgsSerializerTests: XCTestCase {
    func testOptionValue() {
        let witnessArgs = WitnessArgs()
        XCTAssertEqual(
            [16, 0, 0, 0, 16, 0, 0, 0, 16, 0, 0, 0, 16, 0, 0, 0],
            WitnessArgsSerializer(value: witnessArgs).serialize()
        )
    }

    func testEmptyLock() {
        let witnessArgs = WitnessArgs.emptyLock
        XCTAssertEqual(
            [85, 0, 0, 0, 16, 0, 0, 0, 85, 0, 0, 0, 85, 0, 0, 0, 65, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
            WitnessArgsSerializer(value: witnessArgs).serialize()
        )
    }
}
