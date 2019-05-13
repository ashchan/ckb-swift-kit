//
//  Epoch.swift
//  CKB
//
//  Created by James Chen on 2019/05/07.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Epoch: Codable {
    public let number: EpochNumber
    public let blockReward: String
    public let lastBlockHashInPreviousEpoch: H256
    public let startNumber: BlockNumber
    public let length: BlockNumber
    public let difficulty: HexNumber
    public let remainderReward: String

    enum CodingKeys: String, CodingKey {
        case number
        case blockReward = "block_reward"
        case lastBlockHashInPreviousEpoch = "last_block_hash_in_previous_epoch"
        case startNumber = "start_number"
        case length
        case difficulty
        case remainderReward = "remainder_reward"
    }
}
