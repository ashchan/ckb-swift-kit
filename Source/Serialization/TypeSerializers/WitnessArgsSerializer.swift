//
//  WitnessArgsSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public final class WitnessArgsSerializer: TableSerializer<WitnessArgs> {
    public required init(value: WitnessArgs) {
        let serializer: ([Byte]) -> Serializer = { value in
            if value.isEmpty {
                return EmptySerializer()
            }
            return BytesSerializer(value: value)
        }

        super.init(
            value: value,
            fieldSerializers: [
                serializer(Data(hex: value.lock).bytes),
                serializer(Data(hex: value.inputType).bytes),
                serializer(Data(hex: value.outputType).bytes)
            ]
        )
    }
}

public extension WitnessArgs {
    func serialize() -> [UInt8] {
        let serializer = WitnessArgsSerializer(value: self)
        return serializer.serialize()
    }
}
