//
//  DynVecSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class DynVecSerializerTests: XCTestCase {
    typealias BytesSerializer = FixVecSerializer<Byte, ByteSerializer>
    typealias BytesVecSerializer = DynVecSerializer<[Byte], BytesSerializer>

    func testEmptyBytesVector() {
        let emptySerializer = BytesVecSerializer(value: [])
        XCTAssertEqual(emptySerializer.serialize(), [4, 0, 0, 0])
    }

    func testOneItemBytesVector() {
        let oneItemSerializer = BytesVecSerializer(value: [[0x12, 0x34]])
        XCTAssertEqual(
            oneItemSerializer.serialize(),
            [
                0x0e, 0x00, 0x00, 0x00,
                0x08, 0x00, 0x00, 0x00,
                0x02, 0x00, 0x00, 0x00, 0x12, 0x34
            ]
        )
    }

    func testMultiItemsBytesVector() {
        let collectionOfBytes: [[Byte]] = [
            [0x12, 0x34],
            [],
            [0x05, 0x67],
            [0x89],
            [0xab, 0xcd, 0xef]
        ]
        let multiItemsSerializer = BytesVecSerializer(value: collectionOfBytes)
        XCTAssertEqual(
            multiItemsSerializer.serialize(),
            [
                0x34, 0, 0, 0,
                0x18, 0, 0, 0, 0x1e, 0, 0, 0, 0x22, 0, 0, 0, 0x28, 0, 0, 0, 0x2d, 0, 0, 0,
                0x02, 0, 0, 0, 0x12, 0x34,
                0, 0, 0, 0,
                0x02, 0, 0, 0, 0x05, 0x67,
                0x01, 0, 0, 0, 0x89,
                0x03, 0, 0, 0, 0xab, 0xcd, 0xef
            ]
        )
    }
}
