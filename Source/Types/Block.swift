//
//  Block.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Block: Codable {
    public let header: Header
    public let uncles: [UncleBlock]
    public let commitTransactions: [Transaction]
    public let proposalTransactions: [ProposalShortId]

    enum CodingKeys: String, CodingKey {
        case header
        case uncles
        case commitTransactions = "commit_transactions"
        case proposalTransactions = "proposal_transactions"
    }
}

public struct UncleBlock: Codable {
    public let header: Header
    public let cellbase: Transaction
    public let proposalTransactions: [ProposalShortId]

    enum CodingKeys: String, CodingKey {
        case header
        case cellbase
        case proposalTransactions = "proposal_transactions"
    }
}
