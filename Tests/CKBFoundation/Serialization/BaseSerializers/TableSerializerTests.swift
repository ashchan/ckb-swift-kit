//
//  TableSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class TableSerializerTests: XCTestCase {
    func testTableSerializer() {
        typealias Bytes = [Byte]
        typealias Byte3 = [Byte]
        typealias BytesSerializer = FixVecSerializer<Byte, ByteSerializer>

        struct MixedType {
            var f1: Bytes
            var f2: Byte
            var f3: UInt32
            var f4: Byte3
            var f5: Bytes
        }
        let object = MixedType(
            f1: [],
            f2: 0xab,
            f3: 0x123,
            f4: [0x45, 0x67, 0x89],
            f5: [0xab, 0xcd, 0xef]
        )
        let serializer = TableSerializer(
            value: object,
            fieldSerializers: [
                BytesSerializer(value: object.f1),
                ByteSerializer(value: object.f2),
                UInt32Serializer(value: object.f3),
                ArraySerializer<Byte, ByteSerializer>(value: object.f4),
                BytesSerializer(value: object.f5)
            ]
        )
        XCTAssertEqual(
            serializer.serialize(),
            [
                0x2b, 0, 0, 0,
                0x18, 0, 0, 0, 0x1c, 0, 0, 0, 0x1d, 0, 0, 0, 0x21, 0, 0, 0, 0x24, 0, 0, 0,
                0, 0, 0, 0,
                0xab,
                0x23, 0x01, 0, 0,
                0x45, 0x67, 0x89,
                0x03, 0, 0, 0, 0xab, 0xcd, 0xef
            ]
        )
    }
}
