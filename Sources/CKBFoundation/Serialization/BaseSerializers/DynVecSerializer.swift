//
//  DynVecSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Vector with non-fixed size inner items.
struct DynVecSerializer<Item, ItemSerializer>: ObjectSerializer
    where ItemSerializer: ObjectSerializer, Item == ItemSerializer.ObjectType {
    private var items: [Item]

    private var serializedBody = [Byte]()
    private var offsets = [UInt32]()
    private var headerSize: UInt32 {
        return UInt32((1 + items.count) * MemoryLayout<UInt32>.size)
    }
    private var bytesSize: UInt32 {
        return headerSize + UInt32(body.count)
    }

    typealias ObjectType = [Item]

    var header: [Byte] {
        return bytesSize.littleEndianBytes + offsets.flatMap { $0.littleEndianBytes }
    }

    var body: [Byte] {
        return serializedBody
    }

    init(value: [Item]) {
        items = value
        preSerialize()
    }

    // Do not iterate more than once
    private mutating func preSerialize() {
        guard items.count > 0 else {
            return
        }

        let serialized = items.map { ItemSerializer.init(value: $0).serialize() }
        offsets.append(headerSize)
        for serializedItem in serialized.dropLast() {
            offsets.append(offsets.last! + UInt32(serializedItem.count))
        }
        serializedBody = serialized.reduce([], +)
    }
}
