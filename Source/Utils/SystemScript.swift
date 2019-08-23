//
//  SystemScript.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Provided by genesis block to unlock with the default secp256k1 algorithm.
public struct SystemScript {
    public let outPoint: OutPoint
    public let cellTypeHash: H256

    public init(outPoint: OutPoint, cellTypeHash: H256) {
        self.outPoint = outPoint
        self.cellTypeHash = cellTypeHash
    }

    public static func loadSystemScript(nodeUrl: URL) throws -> SystemScript {
        let client = APIClient(url: nodeUrl)
        let genesisBlock = try client.genesisBlock()
        guard genesisBlock.transactions.count >= 2 else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }

        let secp256k1DataCellTransaction = genesisBlock.transactions[0]
        guard secp256k1DataCellTransaction.outputs.count >= 2, let type = secp256k1DataCellTransaction.outputs[1].type else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }
        // TODO: Switch to Script.hash when that's added after serialization/hash change
        let cellTypeHash = try client.computeScriptHash(script: type)

        let systemCellTransaction = genesisBlock.transactions[1]
        let outPoint = OutPoint(txHash: systemCellTransaction.hash, index: "0")

        return SystemScript(outPoint: outPoint, cellTypeHash: cellTypeHash)
    }
}
