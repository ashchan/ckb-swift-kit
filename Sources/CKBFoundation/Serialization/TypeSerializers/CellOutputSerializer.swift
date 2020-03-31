//
//  CellOutputSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

final class CellOutputSerializer: TableSerializer<CellOutput> {
    required init(value: CellOutput) {
        super.init(
            value: value,
            fieldSerializers: [
                UInt64Serializer(value: value.capacity),
                value.lock.serializer,
                OptionSerializer(value: value.type, serializer: value.type?.serializer as? ScriptSerializer)
            ]
        )
    }
}
