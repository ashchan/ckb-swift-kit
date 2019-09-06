//
//  ScriptSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

// Serialization
extension ScriptHashType {
    var byte: UInt8 {
        return self == .data ? 0x0 : 0x1
    }
}

public extension Script {
    func serialize() -> [UInt8] {
        let normalizedArgs: [[Byte]] = args.map { (arg) in
            // TODO: check if Data(hex: arg) needs to left pad arg string
            return Data(hex: arg).bytes
        }
        let serializer = TableSerializer(
            value: self,
            fieldSerializers: [
                Byte32Serializer(value: codeHash)!,
                ByteSerializer(value: hashType.byte),
                DynVecSerializer<[Byte], FixVecSerializer<Byte, ByteSerializer>>(value: normalizedArgs)
            ]
        )
        return serializer.serialize()
    }

    func computeHash() -> H256 {
        let serialized = serialize()
        return Blake2b().hash(bytes: serialized)
    }

    var hash: H256 {
        return computeHash()
    }
}
