//
//  ScriptSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

extension ScriptHashType {
    var byte: UInt8 {
        return self == .data ? 0x0 : 0x1
    }
}

public final class ScriptSerializer: TableSerializer<Script> {
    public required init(value: Script) {
        let normalizedArgs: [[Byte]] = value.args.map { (arg) in
            // TODO: check if Data(hex: arg) needs to left pad arg string
            return Data(hex: arg).bytes
        }
        super.init(
            value: value,
            fieldSerializers: [
                Byte32Serializer(value: value.codeHash)!,
                ByteSerializer(value: value.hashType.byte),
                DynVecSerializer<[Byte], FixVecSerializer<Byte, ByteSerializer>>(value: normalizedArgs)
            ]
        )
    }
}

public extension Script {
    internal var serializer: Serializer {
        return ScriptSerializer(value: self)
    }

    func serialize() -> [UInt8] {
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
