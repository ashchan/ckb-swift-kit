//
//  Block.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct BlockTemplate: Codable {
    let rawHeader: RawHeader
    let uncles: [UncleBlock]
    let commitTransactions: [Transaction]
    let proposalTransactions: [ProposalShortId]

    enum CodingKeys: String, CodingKey {
        case rawHeader = "raw_header"
        case uncles
        case commitTransactions = "commit_transactions"
        case proposalTransactions = "proposal_transactions"
    }
}

public struct Block: Codable, Param {
    let header: Header
    let uncles: [UncleBlock]
    let commitTransactions: [Transaction]
    let proposalTransactions: [ProposalShortId]

    enum CodingKeys: String, CodingKey {
        case header
        case uncles
        case commitTransactions = "commit_transactions"
        case proposalTransactions = "proposal_transactions"
    }

    public var param: [String: Any] {
        return [
            "header": header.param,
            "uncles": uncles.map { $0.param },
            CodingKeys.commitTransactions.rawValue: commitTransactions.map { $0.param },
            CodingKeys.proposalTransactions.rawValue: proposalTransactions
        ]
    }
}

public struct BlockWithHash: Codable {
    let hash: H256
    let header: Header
    let transactions: [TransactionWithHash]
}

public struct UncleBlock: Codable, Param {
    let header: Header
    let cellbase: Transaction
    let proposalTransactions: [ProposalShortId]

    enum CodingKeys: String, CodingKey {
        case header
        case cellbase
        case proposalTransactions = "proposal_transactions"
    }

    public var param: [String: Any] {
        return [
            "header": header.param,
            "cellbase": cellbase.param,
            CodingKeys.proposalTransactions.rawValue: proposalTransactions
        ]
    }
}
