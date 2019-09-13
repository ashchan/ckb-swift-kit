//
//  OutPoint.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct OutPoint: Codable, Param {
    public let txHash: H256
    public let index: UInt32

    enum CodingKeys: String, CodingKey {
        case txHash = "tx_hash"
        case index
    }

    public init(txHash: H256, index: UInt32) {
        self.txHash = txHash
        self.index = index
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        txHash = try container.decode(H256.self, forKey: .txHash)
        index = UInt32(hexValue: try container.decode(String.self, forKey: .index))!
    }

    public var param: [String: Any] {
        return [
            CodingKeys.txHash.rawValue: txHash,
            CodingKeys.index.rawValue: index.hexString
        ]
    }
}
