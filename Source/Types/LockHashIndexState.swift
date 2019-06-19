//
//  LockHashIndexState.swift
//  CKB
//
//  Created by James Chen on 2019/06/19.
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
}
