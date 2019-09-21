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

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        proposalReward = Capacity(hexString: try container.decode(String.self, forKey: .proposalReward))!
        primary = Capacity(hexString: try container.decode(String.self, forKey: .primary))!
        secondary = Capacity(hexString: try container.decode(String.self, forKey: .secondary))!
        total = Capacity(hexString: try container.decode(String.self, forKey: .total))!
        txFee = Capacity(hexString: try container.decode(String.self, forKey: .txFee))!
    }
}
