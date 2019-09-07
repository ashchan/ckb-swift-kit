//
//  CellDepSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

extension DepType {
    var byte: UInt8 {
        return self == .code ? 0x0 : 0x1
    }
}

final class CellDepSerializer: StructSerializer<CellDep> {
    required init(value: CellDep) {
        super.init(
            value: value,
            fieldSerializers: [
                OutPointSerializer(value: value.outPoint),
                ByteSerializer(value: value.depType.byte)
            ]
        )
    }
}
