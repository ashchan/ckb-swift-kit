//
//  TransactionSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension Transaction {
    /// https://github.com/nervosnetwork/ckb/blob/develop/util/types/schemas/ckb.mol#L69
    func serialize() -> [UInt8] {
        let hexStringsToArrayOfBytes: ([HexString]) -> [[Byte]] = { strings in
            return strings.map { Data(hex: $0).bytes }
        }

        let serializer = TableSerializer(
            value: self,
            fieldSerializers: [
                UInt32Serializer(value: version)!,
                FixVecSerializer<CellDep, CellDepSerializer>(value: cellDeps),
                FixVecSerializer<[Byte], Byte32Serializer>(value: hexStringsToArrayOfBytes(headerDeps)),
                FixVecSerializer<CellInput, CellInputSerializer>(value: inputs),
                DynVecSerializer<CellOutput, CellOutputSerializer>(value: outputs),
                DynVecSerializer<[Byte], FixVecSerializer<Byte, ByteSerializer>>(value: hexStringsToArrayOfBytes(outputsData))
            ]
        )
        return serializer.serialize()
    }

    func computeHash() -> H256 {
        let serialized = serialize()
        return Blake2b().hash(bytes: serialized)
    }
}
