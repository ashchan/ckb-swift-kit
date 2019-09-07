//
//  ArraySerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ArraySerializerTests: XCTestCase {
    // MARK: - ArraySerializer
    func testArraySerializer() {
        let arraySerializer = UnsignedIntSerializer<UInt16>(value: UInt16.max.description)!
        XCTAssertEqual(arraySerializer.header, [])
        XCTAssertEqual(arraySerializer.body, [255, 255])
    }

    func testByte3() {
        typealias Byte3Serializer = ArraySerializer<Byte, ByteSerializer>
        XCTAssertEqual(Byte3Serializer(value: [0x01, 0x02, 0x03]).serialize(), [0x01, 0x02, 0x03])
    }

    func testTwoUint32() {
        typealias TwoUint32Serializer = ArraySerializer<UInt32, UInt32Serializer>
        XCTAssertEqual(TwoUint32Serializer(value: [0x01020304, 0xabcde]).serialize(), [0x04, 0x03, 0x02, 0x01, 0xde, 0xbc, 0x0a, 0x00])
    }

    // MARK: - Byte32Serializer
    func testByte32Serializer() {
        let hex = "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3"
        let expected: [Byte] = [231, 159, 50, 7, 234, 73, 128, 183, 254, 215, 153, 86, 213, 147, 66, 73, 206, 172, 71, 81, 164, 250, 224, 26, 15, 124, 74, 150, 136, 75, 196, 227]
        XCTAssertEqual(Byte32Serializer(value: hex)!.serialize(), expected)
        XCTAssertEqual(Byte32Serializer(value: Utils.prefixHex(hex))!.serialize(), expected)

        // Too long
        XCTAssertNil(Byte32Serializer(value: hex + "01"))
        // Too short
        XCTAssertNil(Byte32Serializer(value: String(hex.suffix(62))))
    }
}
