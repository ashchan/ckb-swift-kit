//
//  StructSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// The struct is a fixed-size type: all fields in struct are fixed-size and it has a fixed quantity of fields.
/// The size of a struct is the sum of all fields' size.
struct StructSerializer<T>: ObjectSerializer {
    typealias ObjectType = T
    private var value: T
    private var fieldSerializers: [Serializer]

    var header: [Byte] {
        return []
    }

    var body: [Byte] {
        return fieldSerializers.flatMap { $0.serialize() }
    }

    init(value: T) {
        self.init(value: value, fieldSerializers: [])
    }

    init(value: T, fieldSerializers: [Serializer]) {
        self.value = value
        self.fieldSerializers = fieldSerializers
    }
}
