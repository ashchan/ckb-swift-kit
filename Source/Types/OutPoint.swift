//
//  OutPoint.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct OutPoint: Codable, Param {
    public let txHash: H256
    public let index: Number

    enum CodingKeys: String, CodingKey {
        case txHash = "tx_hash"
        case index
    }

    public init(txHash: H256, index: Number) {
        self.txHash = txHash
        self.index = index
    }

    public var param: [String: Any] {
        return [
            CodingKeys.txHash.rawValue: txHash,
            CodingKeys.index.rawValue: index
        ]
    }
}

public struct CellOutPoint: Codable, Param {
    public let txHash: H256
    public let index: Number

    enum CodingKeys: String, CodingKey {
        case txHash = "tx_hash"
        case index
    }

    public init(txHash: H256, index: Number) {
        self.txHash = txHash
        self.index = index
    }

    public var param: [String: Any] {
        return [
            "tx_hash": txHash,
            "index": index
        ]
    }
}
