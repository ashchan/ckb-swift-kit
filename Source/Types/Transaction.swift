//
//  Transaction.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Transaction: Codable {
    let version: UInt32
    let deps: [OutPoint]
    let inputs: [CellInput]
    let outputs: [CellOutput]
}

public struct TransactionWithHash: Codable {
    let hash: H256
    let transaction: Transaction
}

public struct ProposalShortId: Codable {
    // TODO
}
