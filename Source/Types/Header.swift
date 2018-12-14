//
//  Header.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct RawHeader: Codable, Param {
    let version: UInt32
    let parentHash: H256
    let timestamp: UInt64
    let number: BlockNumber
    let txsCommit: H256
    let txsProposal: H256
    let difficulty: UInt256
    let cellbaseId: H256
    let unclesHash: H256
    let unclesCount: UInt32

    enum CodingKeys: String, CodingKey {
        case version
        case parentHash = "parent_hash"
        case timestamp
        case number
        case txsCommit = "txs_commit"
        case txsProposal = "txs_proposal"
        case difficulty
        case cellbaseId = "cellbase_id"
        case unclesHash = "uncles_hash"
        case unclesCount = "uncles_count"
    }

    public var param: [String: Any] {
        return [
            "version": version,
            CodingKeys.parentHash.rawValue: parentHash,
            "timestamp": timestamp,
            "number": number,
            CodingKeys.txsCommit.rawValue: txsCommit,
            CodingKeys.txsProposal.rawValue: txsProposal,
            "difficulty": difficulty,
            CodingKeys.cellbaseId.rawValue: cellbaseId,
            CodingKeys.unclesHash.rawValue: unclesHash,
            CodingKeys.unclesCount.rawValue: unclesCount
        ]
    }
}

public struct Seal: Codable, Param {
    let nonce: UInt64
    let proof: [UInt8]

    public var param: [String: Any] {
        return [
            "nonce": nonce,
            "proof": proof
        ]
    }
}

public struct Header: Codable, Param {
    let raw: RawHeader
    let seal: Seal

    public var param: [String: Any] {
        return [
            "raw": raw.param,
            "seal": seal.param
        ]
    }
}
