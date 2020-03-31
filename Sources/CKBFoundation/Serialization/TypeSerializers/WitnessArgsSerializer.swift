//
//  WitnessArgsSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension WitnessArgs {
    func serialize() -> [UInt8] {
        switch self {
        case .data(let hex):
            return Data(hex: hex).bytes
        case .parsed(let lock, let inputType, let outputType):
            let serializer: ([Byte]) -> Serializer = { value in
                if value.isEmpty {
                    return EmptySerializer()
                }
                return BytesSerializer(value: value)
            }
            return TableSerializer<WitnessArgs>(
                value: self,
                fieldSerializers: [
                    serializer(Data(hex: lock).bytes),
                    serializer(Data(hex: inputType).bytes),
                    serializer(Data(hex: outputType).bytes)
                ]
            ).serialize()
        }
    }
}
