//
//  FixVecSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class FixVecSerializerTests: XCTestCase {
    func testByteVector() {
        typealias ByteVecSerializer = FixVecSerializer<Byte, ByteSerializer>

        let emptySerializer = ByteVecSerializer(value: [])
        XCTAssertEqual(emptySerializer.serialize(), [0, 0, 0, 0])

        let oneItemSerializer = ByteVecSerializer(value: [12])
        XCTAssertEqual(oneItemSerializer.serialize(), [1, 0, 0, 0, 12])
    }

    func testUint32Vector() {
        typealias Uint32VecSerializer = FixVecSerializer<UInt32, UInt32Serializer>

        let emptySerializer = Uint32VecSerializer(value: [])
        XCTAssertEqual(emptySerializer.serialize(), [0, 0, 0, 0])

        let oneItemSerializer = Uint32VecSerializer(value: [0x123])
        XCTAssertEqual(oneItemSerializer.serialize(), [1, 0, 0, 0, 0x23, 1, 0, 0])

        let sixItemsSerializer = Uint32VecSerializer(value: [0x123, 0x456, 0x7890, 0xa, 0xbc, 0xdef])
        XCTAssertEqual(
            sixItemsSerializer.serialize(),
            [
                0x06, 0x00, 0x00, 0x00,
                0x23, 0x01, 0x00, 0x00,
                0x56, 0x04, 0x00, 0x00,
                0x90, 0x78, 0x00, 0x00,
                0x0a, 0x00, 0x00, 0x00,
                0xbc, 0x00, 0x00, 0x00,
                0xef, 0x0d, 0x00, 0x00
            ]
        )
    }
}
