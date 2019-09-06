//
//  FixVecSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Vector with fixed size inner items.
struct FixVecSerializer<Item, ItemSerializer>: ObjectSerializer
    where ItemSerializer: ObjectSerializer, Item == ItemSerializer.ObjectType {
    typealias ObjectType = [Item]

    var items: [Item]
    var itemsCount: UInt32 {
        return UInt32(items.count)
    }

    var header: [Byte] {
        return itemsCount.littleEndianBytes
    }

    var body: [Byte] {
        items.map { (item) in
            return ItemSerializer.init(value: item).serialize()
        }.reduce([], +)
    }

    init(value: [Item]) {
        items = value
    }
}
