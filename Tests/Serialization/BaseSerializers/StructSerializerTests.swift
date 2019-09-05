//
//  StructSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class StructSerializerTests: XCTestCase {
    func testOnlyAByte() {
        struct OnlyAByte { var f1: Byte }
        let object = OnlyAByte(f1: 0xab)
        let onlyAByteSerializer = StructSerializer([ByteSerializer(value: object.f1)])
        XCTAssertEqual([Byte(0xab)], onlyAByteSerializer.serialize())
    }

    func testByteAndUint32() {
        struct ByteAndUint32 {
            var f1: Byte
            var f2: UInt32
        }
        let object = ByteAndUint32(f1: 0xab, f2: 66051/*0x010203*/)
        let byteAndUint32Serializer = StructSerializer([
            ByteSerializer(value: object.f1),
            UInt32Serializer(value: object.f2)
        ])
        let expected: [Byte] = [0xab, 0x03, 0x02, 0x01, 0x00]
        XCTAssertEqual(expected, byteAndUint32Serializer.serialize())
    }
}
