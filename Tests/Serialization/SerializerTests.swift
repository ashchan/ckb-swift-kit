//
//  SerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class SerializerTests: XCTestCase {
    func testUIntLittleEndianBytes() {
        XCTAssertEqual(UInt16.max.littleEndianBytes, [255, 255])
        XCTAssertEqual(UInt16(1).littleEndianBytes, [1, 0])

        XCTAssertEqual(UInt32.max.littleEndianBytes, [UInt8](repeating: 255, count: 4))
        XCTAssertEqual(UInt32(1).littleEndianBytes, [1, 0, 0, 0])

        XCTAssertEqual(UInt64.max.littleEndianBytes, [UInt8](repeating: 255, count: 8))
        XCTAssertEqual(UInt64(1).littleEndianBytes, [1, 0, 0, 0, 0, 0, 0, 0])
    }

    // MARK: - UInt32Serializer
    func testUInt32Serializer() {
        // 0x01020304
        let expected: [Byte] = [4, 3, 2, 1]
        XCTAssertEqual(UInt32Serializer(value: 16909060).serialize(), expected)
        XCTAssertEqual(UInt32Serializer(value: "16909060")!.serialize(), expected)
        XCTAssertEqual(UInt32Serializer(value: "0x01020304")!.serialize(), expected)

        // Overflow
        XCTAssertNil(UInt32Serializer(value: (UInt64(UInt32.max) + 1).description))
        // Underflow
        XCTAssertNil(UInt32Serializer(value: "-1"))
    }

    // MARK: - UInt64Serializer
    func testUInt64Serializer() {
        let max = UInt64.max
        let expected: [Byte] = [Byte](repeating: 255, count: 8)
        XCTAssertEqual(UInt64Serializer(value: max).serialize(), expected)
        XCTAssertEqual(UInt64Serializer(value: max.description)!.serialize(), expected)

        // Overflow
        XCTAssertNil(UInt64Serializer(value: UInt64.max.description + "1"))
        // Underflow
        XCTAssertNil(UInt64Serializer(value: "-1"))
    }
}
