//
//  LockHashIndexState.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct LockHashIndexState: Codable {
    public let lockHash: H256
    public let blockNumber: BlockNumber
    public let blockHash: H256

    enum CodingKeys: String, CodingKey {
        case lockHash = "lock_hash"
        case blockNumber = "block_number"
        case blockHash = "block_hash"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lockHash = try container.decode(H256.self, forKey: .lockHash)
        blockNumber = BlockNumber(hexString: try container.decode(String.self, forKey: .blockNumber))!
        blockHash = try container.decode(H256.self, forKey: .blockHash)
    }
}
