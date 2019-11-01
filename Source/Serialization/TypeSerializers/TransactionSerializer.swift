//
//  TransactionSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// https://github.com/nervosnetwork/ckb/blob/develop/util/types/schemas/blockchain.mol#L55-L67
public final class TransactionSerializer: TableSerializer<Transaction> {
    public required init(value: Transaction) {
        let hexStringsToArrayOfBytes: ([HexString]) -> [[Byte]] = { strings in
            return strings.map { Data(hex: $0).bytes }
        }
        super.init(
            value: value,
            fieldSerializers: [
                UInt32Serializer(value: value.version),
                FixVecSerializer<CellDep, CellDepSerializer>(value: value.cellDeps),
                FixVecSerializer<[Byte], Byte32Serializer>(value: hexStringsToArrayOfBytes(value.headerDeps)),
                FixVecSerializer<CellInput, CellInputSerializer>(value: value.inputs),
                DynVecSerializer<CellOutput, CellOutputSerializer>(value: value.outputs),
                DynVecSerializer<[Byte], BytesSerializer>(value: hexStringsToArrayOfBytes(value.outputsData))
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

// - MARK: Size & Fee

final class TransactionPlusWitnessesSerializer: TableSerializer<Transaction> {
    required init(value: Transaction) {
        let witnesses: [[Byte]]
        if value.witnesses.isEmpty {
            witnesses = value.serializeWitnessArgs()
        } else {
            witnesses = value.witnesses.map { Data(hex: $0).bytes }
        }

        super.init(
            value: value,
            fieldSerializers: [
                TransactionSerializer(value: value),
                DynVecSerializer<[Byte], BytesSerializer>(value: witnesses)
            ]
        )
    }
}

extension Transaction {
    var serializedSizeInBlock: Int {
        let serializer = TransactionPlusWitnessesSerializer(value: self)
        let serializedTxOffsetBytesize = 4 // 4 bytes for the tx offset cost with molecule array (transactions)
        return serializer.serialize().count + serializedTxOffsetBytesize
    }

    public func fee(rate: UInt64) -> Capacity {
        return Transaction.fee(for: serializedSizeInBlock, with: rate)
    }

    func serializeWitnessArgs() -> [[Byte]] {
        return unsignedWitnesses.map { (witnessArgs) in
            return WitnessArgsSerializer(value: witnessArgs).serialize()
        }
    }

    /// Calulate fee based on transaction size and fee rate.
    /// - Parameter txSize: Bytesize of the serialized tx in a block
    /// - Parameter rate: Fee rate, shannons for 1KB
    public static func fee(for txSize: Int, with rate: UInt64) -> Capacity {
        let base = UInt64(txSize) * rate
        let result = base / 1000
        return base % 1000 == 0 ? result : result + 1
    }
}
