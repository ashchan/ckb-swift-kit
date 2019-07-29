//
//  BlockReward.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct BlockReward: Codable {
    public let proposalReward: Capacity
    public let primary: Capacity
    public let secondary: Capacity
    public let total: Capacity
    public let txFee: Capacity

    enum CodingKeys: String, CodingKey {
        case proposalReward = "proposal_reward"
        case primary
        case secondary
        case total
        case txFee = "tx_fee"
    }
}
