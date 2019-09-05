//
//  ByteSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

struct ByteSerializer: Serializer {
    private let byte: Byte

    var header: [Byte] {
        return []
    }

    var body: [Byte] {
        return [byte]
    }

    init(value: Byte) {
        byte = value
    }

    init?(value: String) {
        guard let byte = Byte(value) else {
            return nil
        }
        self.init(value: byte)
    }
}
