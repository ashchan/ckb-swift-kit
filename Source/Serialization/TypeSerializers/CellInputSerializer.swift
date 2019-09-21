//
//  CellInputSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

final class CellInputSerializer: StructSerializer<CellInput> {
    required init(value: CellInput) {
        super.init(
            value: value,
            fieldSerializers: [
                UInt64Serializer(value: value.since),
                OutPointSerializer(value: value.previousOutput)
            ]
        )
    }
}
