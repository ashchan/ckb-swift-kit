//
//  SystemScript.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct SystemScript {
    public let outPoint: OutPoint
    public let codeHash: H256

    public init(outPoint: OutPoint, codeHash: H256) {
        self.outPoint = outPoint
        self.codeHash = codeHash
    }

    /// System cell genesis block which has a default secp256k1 implementation for testnet/dev.
    public static func loadFromGenesisBlock(nodeUrl: URL) throws -> SystemScript {
        let client = APIClient(url: nodeUrl)
        let genesisBlock = try client.genesisBlock()
        guard let systemCellTransaction = genesisBlock.transactions.first else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }

        let outputIndex = 1
        let outPoint = OutPoint(cell: CellOutPoint(txHash: systemCellTransaction.hash, index: outputIndex.description))
        guard systemCellTransaction.outputs.count > outputIndex else {
            throw APIError.genericError("Fail to get data from system cell tx's outputs[\(outputIndex)]")
        }
        let data = Data(hex: systemCellTransaction.outputs[outputIndex].data)
        guard let codeHash = Blake2b().hash(data: data) else {
            throw APIError.genericError("Fail to calculate cell hash of data from system cell tx's outputs[\(outputIndex)]")
        }

        return SystemScript(outPoint: outPoint, codeHash: Utils.prefixHex(codeHash.toHexString()))
    }
}
