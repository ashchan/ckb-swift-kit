//
//  ByteSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ByteSerializerTests: XCTestCase {
    func testByteSerializer() {
        XCTAssertEqual(ByteSerializer(value: UInt8(255)).serialize(), [255])

        // Overflow
        XCTAssertNil(ByteSerializer(value: "256"))
        // Underflow
        XCTAssertNil(ByteSerializer(value: "-1"))
    }
}
