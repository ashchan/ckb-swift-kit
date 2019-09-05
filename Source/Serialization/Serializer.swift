//
//  Serializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

// CKB Types serialization schema
// https://github.com/nervosnetwork/ckb/blob/develop/util/types/schemas/ckb.mol

// Primitive Type
typealias Byte = UInt8

protocol Serializer {
    var header: [Byte] { get }
    var body: [Byte] { get }

    // Serialize as bytes
    func serialize() -> [Byte]
}

extension Serializer {
    func serialize() -> [Byte] {
        return header + body
    }
}

extension UnsignedInteger where Self: FixedWidthInteger {
    var littleEndianBytes: [Byte] {
        var value = littleEndian
        let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        return data.bytes
    }
}
