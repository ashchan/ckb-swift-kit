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
    public let transactions: [Transaction]
    public let proposals: [ProposalShortId]
}

public struct UncleBlock: Codable {
    public let header: Header
    public let proposals: [ProposalShortId]
}
