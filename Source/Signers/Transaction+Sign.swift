//
//  Transaction+Sign.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension Transaction {
    static func sign(tx: Transaction, with privateKey: Data) throws -> Transaction {
        if tx.witnesses.count < tx.inputs.count {
            throw Error.invalidNumberOfWitnesses
        }

        let txHash: H256 = tx.computeHash()

        let signedWitnesses = try tx.witnesses.map { witness -> HexString in
            let message: Data = [txHash, witness].map { Data(hex: $0) }.reduce(Data(), +)
            guard let messageHash = Blake2b().hash(data: message) else {
                throw Error.failToHashWitnessesData
            }
            guard let signature = Secp256k1.signRecoverable(privateKey: privateKey, data: messageHash) else {
                throw Error.failToSignWitnessesData
            }
            return Utils.prefixHex(signature.toHexString()) + Utils.removeHexPrefix(witness)
        }

        return Transaction(
            version: tx.version,
            cellDeps: tx.cellDeps,
            headerDeps: tx.headerDeps,
            inputs: tx.inputs,
            outputs: tx.outputs,
            outputsData: tx.outputsData,
            witnesses: signedWitnesses,
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
