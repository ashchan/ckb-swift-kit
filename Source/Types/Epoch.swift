//
//  Epoch.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Epoch: Codable {
    public let number: EpochNumber
    public let epochReward: String
    public let startNumber: BlockNumber
    public let length: BlockNumber
    public let difficulty: HexNumber

    enum CodingKeys: String, CodingKey {
        case number
        case epochReward = "epoch_reward"
        case startNumber = "start_number"
        case length
        case difficulty
    }
}
