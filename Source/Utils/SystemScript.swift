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

    /// System script from genesis block which embeds a default secp256k1 implementation.
    public static func loadSystemScript(nodeUrl: URL) throws -> SystemScript {
        let client = APIClient(url: nodeUrl)
        let genesisBlock = try client.genesisBlock()
        guard let systemCellTransaction = genesisBlock.transactions.first else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }

        let outputIndex = 1
        let outPoint = OutPoint(txHash: systemCellTransaction.hash, index: outputIndex.description)
        guard systemCellTransaction.outputs.count > outputIndex else {
            throw APIError.genericError("Fail to get data from system cell tx's outputs[\(outputIndex)]")
        }
        let data = Data(hex: systemCellTransaction.outputsData[outputIndex])
        guard let codeHash = Blake2b().hash(data: data) else {
            throw APIError.genericError("Fail to calculate cell hash of data from system cell tx's outputs[\(outputIndex)]")
        }

        return SystemScript(outPoint: outPoint, codeHash: Utils.prefixHex(codeHash.toHexString()))
    }

    /// System script (dep group) from genesis block which embeds a default secp256k1 implementation.
    public static func loadDepGroupSystemScript(nodeUrl: URL) throws -> SystemScript {
        let client = APIClient(url: nodeUrl)
        let genesisBlock = try client.genesisBlock()
        guard genesisBlock.transactions.count >= 2 else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }
        let systemCellTransaction = genesisBlock.transactions[1]

        let outputIndex = 0
        let outPoint = OutPoint(txHash: systemCellTransaction.hash, index: outputIndex.description)

        return SystemScript(outPoint: outPoint, codeHash: H256.zeroHash)
    }
}
