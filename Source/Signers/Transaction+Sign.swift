//
//  Transaction+Sign.swift
//  CKB
//
//  Created by James Chen on 2019/05/15.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension Transaction {
    static func sign(tx: Transaction, with privateKey: Data, txHash: H256) -> Transaction {
        let publicKey = Secp256k1.privateToPublic(privateKey: privateKey)

        let signedWitnesses = tx.witnesses.map { witness -> Witness in
            let message: Data = ([txHash] + witness.data).map { Data(hex: $0) }.reduce(Data(), +)
            let messageHash = Blake2b().hash(data: message)!
            let signature = Secp256k1.sign(privateKey: privateKey, data: messageHash)!
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
}
