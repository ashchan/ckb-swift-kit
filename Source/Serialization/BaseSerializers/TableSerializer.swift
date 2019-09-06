//
//  TableSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// The table is a dynamic-size type.
/// It can be considered as a dynvec but the length is fixed.
public class TableSerializer<T>: ObjectSerializer {
    typealias ObjectType = T
    private var value: T
    private var fieldSerializers: [Serializer]

    private var serializedBody = [Byte]()
    private var offsets = [UInt32]()
    private var headerSize: UInt32 {
        return UInt32((1 + fieldSerializers.count) * MemoryLayout<UInt32>.size)
    }
    private var bytesSize: UInt32 {
        return headerSize + UInt32(body.count)
    }

    var header: [Byte] {
        return bytesSize.littleEndianBytes + offsets.flatMap { $0.littleEndianBytes }
    }

    var body: [Byte] {
        return serializedBody
    }

    required convenience init(value: T) {
        self.init(value: value, fieldSerializers: [])
    }

    init(value: T, fieldSerializers: [Serializer]) {
        self.value = value
        self.fieldSerializers = fieldSerializers
        preSerialize()
    }

    // Do not iterate more than once
    private func preSerialize() {
        guard fieldSerializers.count > 0 else {
            return
        }

        let serialized = fieldSerializers.map { $0.serialize() }
        offsets.append(headerSize)
        for serializedItem in serialized.dropLast() {
            offsets.append(offsets.last! + UInt32(serializedItem.count))
        }
        serializedBody = serialized.reduce([], +)
    }
}
