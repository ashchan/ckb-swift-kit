//
//  Serializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

// [CKB Serialization RFC](https://github.com/yangby-cryptape/rfcs/blob/pr/serialization/rfcs/0008-serialization/0008-serialization.md)
// [CKB Types serialization schema](https://github.com/nervosnetwork/ckb/blob/develop/util/types/schemas/blockchain.mol)

// Primitive Type
public typealias Byte = UInt8

public protocol Serializer {
    var header: [Byte] { get }
    var body: [Byte] { get }

    // Serialize as bytes
    func serialize() -> [Byte]
}

public extension Serializer {
    func serialize() -> [Byte] {
        return header + body
    }
}

public protocol ObjectSerializer: Serializer {
    associatedtype ObjectType

    init(value: ObjectType)
}

public extension UnsignedInteger where Self: FixedWidthInteger {
    var littleEndianBytes: [Byte] {
        var value = littleEndian
        let data = Data(bytes: &value, count: MemoryLayout.size(ofValue: value))
        return data.bytes
    }
}

// Unsigned Integer, little-endian
public struct UnsignedIntSerializer<T>: ObjectSerializer where T: UnsignedInteger & FixedWidthInteger {
    public typealias ObjectType = T
    private let value: T

    public var header: [Byte] {
        return []
    }

    public var body: [Byte] {
        return value.littleEndianBytes
    }

    public init(value: T) {
        self.value = value
    }

    public init?(value: String) {
        guard let uint = value.starts(with: "0x") ? T(value.dropFirst(2), radix: 16) : T(value) else {
            return nil
        }
        self.init(value: uint)
    }
}

// UInt32 (4 bytes), little-endian
public typealias UInt32Serializer = UnsignedIntSerializer<UInt32>

// UInt64 (8 bytes), little-endian
public typealias UInt64Serializer = UnsignedIntSerializer<UInt64>
