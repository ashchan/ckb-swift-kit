//
//  OptionSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

struct OptionSerializer<T, TSerializer: Serializer>: ObjectSerializer {
    typealias ObjectType = T?
    private var value: T?
    private var serializer: TSerializer?

    var header: [Byte] {
        return []
    }

    var body: [Byte] {
        if value != nil, let serializer = serializer {
            return serializer.serialize()
        }
        return []
    }

    init(value: T?, serializer: TSerializer? = nil) {
        self.value = value
        self.serializer = serializer
    }

    init(value: T?) {
        self.init(value: value, serializer: nil)
    }
}
