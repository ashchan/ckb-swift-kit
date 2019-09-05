//
//  ArraySerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// The array is a fixed-size type: it has a fixed-size inner type and a fixed length.
/// The size of an array is the size of inner type times the length.
protocol ArraySerializer: Serializer {
    associatedtype Element
    var elements: [Element] { get }
    var length: Int { get }
}

extension ArraySerializer where Element == Byte {
    var header: [Byte] {
        return []
    }

    var body: [Byte] {
        return elements
    }
}

// 32 bytes
struct Byte32Serializer: ArraySerializer {
    typealias Element = Byte
    var elements: [Element]
    var length: Int {
        return 32
    }

    init?(value: [Byte]) {
        elements = value
        guard value.count == self.length else {
            return nil
        }
    }

    init?(value: HexString) {
        self.init(value: Data(hex: value).bytes)
    }
}
// Unsigned Integer, little-endian
struct UnsignedIntSerializer<T>: ArraySerializer where T: UnsignedInteger & FixedWidthInteger {
    typealias Element = Byte
    var elements: [Element]
    var length: Int {
        return MemoryLayout<T>.size
    }

    init(value: T) {
        elements = value.littleEndianBytes
    }

    init?(value: Number) {
        guard let uint = T(value) else {
            return nil
        }
        self.init(value: uint)
    }
}

// UInt32 (4 bytes), little-endian
typealias UInt32Serializer = UnsignedIntSerializer<UInt32>

// UInt64 (8 bytes), little-endian
typealias UInt64Serializer = UnsignedIntSerializer<UInt64>
