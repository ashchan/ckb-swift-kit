//
//  Header.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Header: Codable {
    public let version: Version
    public let parentHash: H256
    public let timestamp: Date
    public let number: BlockNumber
    public let epoch: EpochNumber
    public let transactionsRoot: H256
    public let proposalsHash: H256
    public let unclesHash: H256
    public let dao: String
    public let nonce: UInt64
    public let compactTarget: UInt32 // TODO: Wait for CKB to update it to hex string
    public let hash: H256

    enum CodingKeys: String, CodingKey {
        case version
        case parentHash = "parent_hash"
        case timestamp
        case number
        case epoch
        case transactionsRoot = "transactions_root"
        case proposalsHash = "proposals_hash"
        case unclesHash = "uncles_hash"
        case dao
        case nonce
        case compactTarget = "compact_target"
        case hash
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = Version(hexString: try container.decode(String.self, forKey: .version))!
        parentHash = try container.decode(H256.self, forKey: .parentHash)
        timestamp = Date(hexSince1970: try container.decode(String.self, forKey: .timestamp))
        number = BlockNumber(hexString: try container.decode(String.self, forKey: .number))!
        epoch = EpochNumber(hexString: try container.decode(String.self, forKey: .epoch))!
        transactionsRoot = try container.decode(H256.self, forKey: .transactionsRoot)
        proposalsHash = try container.decode(H256.self, forKey: .proposalsHash)
        unclesHash = try container.decode(H256.self, forKey: .unclesHash)
        dao = try container.decode(String.self, forKey: .dao)
        nonce = UInt64(hexString: try container.decode(String.self, forKey: .nonce))!
        compactTarget = try container.decode(UInt32.self, forKey: .compactTarget)
        hash = try container.decode(H256.self, forKey: .hash)
    }
}
