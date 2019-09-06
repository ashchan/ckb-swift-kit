//
//  OutPointSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

final class OutPointSerializer: StructSerializer<OutPoint> {
    required init(value: OutPoint) {
        super.init(
            value: value,
            fieldSerializers: [
                Byte32Serializer(value: value.txHash)!,
                UInt32Serializer(value: value.index)!
            ]
        )
    }
}
