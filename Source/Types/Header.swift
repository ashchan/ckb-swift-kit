//
//  Header.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Seal: Codable {
    public let nonce: UInt64
    public let proof: HexString
}

public struct Header: Codable {
    public let version: UInt32
    public let parentHash: H256
    public let timestamp: UInt64
    public let number: BlockNumber
    public let txsCommit: H256
    public let txsProposal: H256
    public let witnessesRoot: H256
    public let difficulty: UInt256
    public let unclesHash: H256
    public let unclesCount: UInt32
    public let hash: H256

    public let seal: Seal

    enum CodingKeys: String, CodingKey {
        case version
        case parentHash = "parent_hash"
        case timestamp
        case number
        case txsCommit = "txs_commit"
        case txsProposal = "txs_proposal"
        case witnessesRoot = "witnesses_root"
        case difficulty
        case unclesHash = "uncles_hash"
        case unclesCount = "uncles_count"
        case hash
        case seal
    }
}
