//
//  Transaction+Sign.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import CKBFoundation

public extension Transaction {
    /// Sign a transaction's witnesses data with private key.
    /// Note this doesn't support multiple input groups yet.
    /// - Parameter tx: The transaction to sign. It should include collected inputs and unsigned witnesses.
    /// - Parameter privateKey: The private key to sign the transaction.
    ///
    /// - Returns: Signed transaction.
    static func sign(tx: Transaction, with privateKey: Data) throws -> Transaction {
        guard let firstWitness = tx.unsignedWitnesses.first, case let .parsed(_, inputType, outputType) = firstWitness else {
            throw Error.invalidNumberOfWitnesses
        }

        let txHash: H256 = tx.computeHash()
        let emptyWitness = WitnessArgs.parsed(WitnessArgs.emptyLockHash, inputType, outputType)
        let emptiedWitnessData = Data(emptyWitness.serialize())
        var message = Data(hex: txHash)
        message += Data(UInt64Serializer(value: UInt64(emptiedWitnessData.count)).serialize())
        message += emptiedWitnessData

        tx.unsignedWitnesses.dropFirst().forEach { (witnessArg) in
            let witnessData = Data(witnessArg.serialize())
            message += Data(UInt64Serializer(value: UInt64(witnessData.count)).serialize())
            message += witnessData
        }

        guard let messageHash = Blake2b().hash(data: message) else {
            throw Error.failToHashWitnessesData
        }
        guard let signature = Secp256k1.signRecoverable(privateKey: privateKey, data: messageHash) else {
            throw Error.failToSignWitnessesData
        }

        let witnesses: [HexString] = tx.unsignedWitnesses.enumerated().map { (index, witnessArgs) in
            let args = index == 0 ? .parsed(Utils.prefixHex(signature.toHexString()), inputType, outputType) : witnessArgs
            return Utils.prefixHex(args.serialize().toHexString())
        }

        return Transaction(
            version: tx.version,
            cellDeps: tx.cellDeps,
            headerDeps: tx.headerDeps,
            inputs: tx.inputs,
            outputs: tx.outputs,
            outputsData: tx.outputsData,
            witnesses: witnesses,
            hash: txHash
        )
    }

    enum Error: Swift.Error, LocalizedError {
        case invalidNumberOfWitnesses
        case failToHashWitnessesData
        case failToSignWitnessesData

        public var errorDescription: String? {
            switch self {
            case .invalidNumberOfWitnesses:
                return "Invalid number of witnesses."
            case .failToHashWitnessesData:
                return "Fail to hash witnesses data."
            case .failToSignWitnessesData:
                return "Fail to sign witnesses data."
            }
        }
    }
}
