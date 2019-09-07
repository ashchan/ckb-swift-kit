//
//  ArraySerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// The array is a fixed-size type: it has a fixed-size inner type and a fixed length.
/// The size of an array is the size of inner type times the length.
struct ArraySerializer<Item, ItemSerializer>: ObjectSerializer
    where ItemSerializer: ObjectSerializer, Item == ItemSerializer.ObjectType {
    typealias ObjectType = [Item]

    private var items: [Item]

    var header: [Byte] {
        return []
    }

    var body: [Byte] {
        return items.flatMap { ItemSerializer.init(value: $0).serialize() }
    }

    init(value: [Item]) {
        items = value
    }
}

// 32 bytes, good for H256 (hash values)
typealias Byte32Serializer = ArraySerializer<Byte, ByteSerializer>
extension Byte32Serializer {
    // BUGBUGBUG: This would affect normal ArraySerializer<Byte, ByteSerializer>!
    init?(value: HexString) {
        let data = Data(hex: value).bytes
        guard data.count == 32 else {
            // TODO: Left padding?
            return nil
        }
        self.init(value: data)
    }
}
