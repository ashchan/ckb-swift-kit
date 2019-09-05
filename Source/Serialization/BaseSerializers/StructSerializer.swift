//
//  StructSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// The struct is a fixed-size type: all fields in struct are fixed-size and it has a fixed quantity of fields.
/// The size of a struct is the sum of all fields' size.
struct StructSerializer: Serializer {
    private let fieldSerializers: [Serializer]

    var header: [Byte] {
        return []
    }

    var body: [Byte] {
        return fieldSerializers.map { $0.serialize() }.reduce([], +)
    }

    init(_ fieldSerializers: [Serializer]) {
        self.fieldSerializers = fieldSerializers
    }
}
