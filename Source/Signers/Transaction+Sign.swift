//
//  Transaction+Sign.swift
//  CKB
//
//  Created by James Chen on 2019/05/15.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension Transaction {
    static func sign(tx: Transaction, with privateKey: Data, txHash: H256) throws -> Transaction {
        if tx.witnesses.count < tx.inputs.count {
            throw Error.invalidNumberOfWitnesses
        }

        let publicKey = Secp256k1.privateToPublic(privateKey: privateKey)

        let signedWitnesses = try tx.witnesses.map { witness -> Witness in
            let message: Data = ([txHash] + witness.data).map { Data(hex: $0) }.reduce(Data(), +)
            guard let messageHash = Blake2b().hash(data: message) else {
                throw Error.failToHashWitnessesData
            }
            guard let signature = Secp256k1.sign(privateKey: privateKey, data: messageHash) else {
                throw Error.failToSignWitnessesData
            }
            let data = [ publicKey.toHexString(), signature.toHexString() ] + witness.data
            return Witness(data: data.map { Utils.prefixHex($0) })
        }

        return Transaction(
            version: tx.version,
            deps: tx.deps,
            inputs: tx.inputs,
            outputs: tx.outputs,
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
