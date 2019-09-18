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

    public static func loadSystemScript(apiClient: APIClient) throws -> SystemScript {
        let genesisBlock = try apiClient.genesisBlock()
        guard genesisBlock.transactions.count >= 2 else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }

        let systemCellTransaction = genesisBlock.transactions[0]
        guard systemCellTransaction.outputs.count >= 2, let type = systemCellTransaction.outputs[1].type else {
            throw APIError.genericError("Fail to fetch system cell tx from genesis block.")
        }
        let secp256k1TypeHash = type.hash

        let depOutPoint = OutPoint(txHash: genesisBlock.transactions[1].hash, index: 0)

        return SystemScript(depOutPoint: depOutPoint, secp256k1TypeHash: secp256k1TypeHash)
    }

    public static func loadSystemScript(nodeUrl: URL) throws -> SystemScript {
        return try loadSystemScript(apiClient: APIClient(url: nodeUrl))
    }

    public func lock(for publicKey: Data) -> Script {
        let publicKeyHash = AddressGenerator().hash(for: publicKey).toHexString()
        return lock(for: publicKeyHash)
    }

    public func lock(for publicKeyHash: String) -> Script {
        return Script(args: [Utils.prefixHex(publicKeyHash)], codeHash: secp256k1TypeHash, hashType: .type)
    }
}
