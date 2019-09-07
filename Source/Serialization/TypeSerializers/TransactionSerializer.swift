//
//  TransactionSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

 /// https://github.com/nervosnetwork/ckb/blob/develop/util/types/schemas/ckb.mol#L69
public final class TransactionSerializer: TableSerializer<Transaction> {
    public required init(value: Transaction) {
        let hexStringsToArrayOfBytes: ([HexString]) -> [[Byte]] = { strings in
            return strings.map { Data(hex: $0).bytes }
        }
        super.init(
            value: value,
            fieldSerializers: [
                UInt32Serializer(value: value.version)!,
                FixVecSerializer<CellDep, CellDepSerializer>(value: value.cellDeps),
                FixVecSerializer<[Byte], Byte32Serializer>(value: hexStringsToArrayOfBytes(value.headerDeps)),
                FixVecSerializer<CellInput, CellInputSerializer>(value: value.inputs),
                DynVecSerializer<CellOutput, CellOutputSerializer>(value: value.outputs),
                DynVecSerializer<[Byte], FixVecSerializer<Byte, ByteSerializer>>(value: hexStringsToArrayOfBytes(value.outputsData))
            ]
        )
    }
}

public extension Transaction {
    func serialize() -> [UInt8] {
        let serializer = TransactionSerializer(value: self)
        return serializer.serialize()
    }

    func computeHash() -> H256 {
        let serialized = serialize()
        return Blake2b().hash(bytes: serialized)
    }
}
