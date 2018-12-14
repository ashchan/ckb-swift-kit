//
//  Header.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct RawHeader: Codable {
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
}

public struct Seal: Codable {
    let nonce: UInt64
    let proof: [UInt8]
}

public struct Header: Codable {
    let raw: RawHeader
    let seal: Seal
}
