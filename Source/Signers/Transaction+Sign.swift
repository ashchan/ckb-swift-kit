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
        let signature = Secp256k1.sign(privateKey: privateKey, data: Data(hex: txHash))!
        let size = withUnsafeBytes(of: UInt64(signature.count).littleEndian) { Data($0) }

        let data = [ publicKey, signature, size ]
        let witness = Witness(data: data.map { Utils.prefixHex($0.toHexString()) })
        let witnesses = [Witness](repeating: witness, count: tx.inputs.count)

        return Transaction(
            version: tx.version,
            deps: tx.deps,
            inputs: tx.inputs,
            outputs: tx.outputs,
            witnesses: witnesses,
            hash: txHash
        )
    }
}
