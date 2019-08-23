//
//  SystemScript.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Provided by genesis block to unlock with the default secp256k1 algorithm.
public struct SystemScript {
    public let depOutPoint: OutPoint
    public let secp256k1TypeHash: H256

    public init(depOutPoint: OutPoint, secp256k1TypeHash: H256) {
        self.depOutPoint = depOutPoint
        self.secp256k1TypeHash = secp256k1TypeHash
    }

    public static func loadSystemScript(nodeUrl: URL) throws -> SystemScript {
        let client = APIClient(url: nodeUrl)
        let genesisBlock = try client.genesisBlock()
        guard genesisBlock.transactions.count >= 2 else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }

        let systemCellTransaction = genesisBlock.transactions[0]
        guard systemCellTransaction.outputs.count >= 2, let type = systemCellTransaction.outputs[1].type else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }
        // TODO: Switch to Script.hash when that's added after serialization/hash change
        let secp256k1TypeHash = try client.computeScriptHash(script: type)

        let depOutPoint = OutPoint(txHash: genesisBlock.transactions[1].hash, index: "0")

        return SystemScript(depOutPoint: depOutPoint, secp256k1TypeHash: secp256k1TypeHash)
    }
}
