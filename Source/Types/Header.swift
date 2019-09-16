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
    public let witnessesRoot: H256
    public let difficulty: HexNumber
    public let unclesHash: H256
    public let unclesCount: UInt32
    public let dao: String
    public let chainRoot: String
    public let nonce: UInt64
    public let hash: H256

    enum CodingKeys: String, CodingKey {
        case version
        case parentHash = "parent_hash"
        case timestamp
        case number
        case epoch
        case transactionsRoot = "transactions_root"
        case proposalsHash = "proposals_hash"
        case witnessesRoot = "witnesses_root"
        case difficulty
        case unclesHash = "uncles_hash"
        case unclesCount = "uncles_count"
        case dao
        case chainRoot = "chain_root"
        case nonce
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
        witnessesRoot = try container.decode(H256.self, forKey: .witnessesRoot)
        difficulty = try container.decode(HexString.self, forKey: .difficulty)
        unclesHash = try container.decode(H256.self, forKey: .unclesHash)
        unclesCount = UInt32(hexString: try container.decode(String.self, forKey: .unclesCount))!
        dao = try container.decode(String.self, forKey: .dao)
        chainRoot = try container.decode(String.self, forKey: .chainRoot)
        nonce = UInt64(hexString: try container.decode(String.self, forKey: .nonce))!
        hash = try container.decode(H256.self, forKey: .hash)
    }
}
