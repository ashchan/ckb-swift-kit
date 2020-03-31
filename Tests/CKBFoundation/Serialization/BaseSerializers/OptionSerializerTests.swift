//
//  OptionSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class OptionSerializerTests: XCTestCase {
    struct TableType {
        var f1: Byte
        var f2: UInt32

        var serializer: Serializer {
            return TableSerializer(
                value: self,
                fieldSerializers: [
                    ByteSerializer(value: f1),
                    UInt32Serializer(value: f2)
                ]
            )
        }
    }

    func testNonEmptyObject() {
        let object = TableType(f1: 0x01, f2: 2)
        let serializer = TableSerializer(
            value: object,
            fieldSerializers: [
                ByteSerializer(value: object.f1),
                UInt32Serializer(value: object.f2)
            ]
        )
        let optionSerializer = OptionSerializer(value: object, serializer: serializer)
        XCTAssertEqual(
            optionSerializer.serialize(),
            [17, 0, 0, 0, 12, 0, 0, 0, 13, 0, 0, 0, 1, 2, 0, 0, 0]
        )
    }

    func testEmptyObject() {
        let object: TableType? = nil
        let serializer = TableSerializer(
            value: object,
            fieldSerializers: [
                ByteSerializer(value: 1),
                UInt32Serializer(value: 2)
            ]
        )
        let optionSerializer = OptionSerializer(value: object, serializer: serializer)
        XCTAssertEqual(
            optionSerializer.serialize(),
            []
        )
    }
}
