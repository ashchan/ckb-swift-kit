//
//  Epoch.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Epoch: Codable {
    public let number: EpochNumber
    public let startNumber: BlockNumber
    public let length: BlockNumber
    public let difficulty: HexNumber

    enum CodingKeys: String, CodingKey {
        case number
        case startNumber = "start_number"
        case length
        case difficulty
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = EpochNumber(hexValue: try container.decode(String.self, forKey: .number))!
        startNumber = BlockNumber(hexValue: try container.decode(String.self, forKey: .startNumber))!
        length = BlockNumber(hexValue: try container.decode(String.self, forKey: .length))!
        difficulty = try container.decode(HexNumber.self, forKey: .difficulty)
    }
}
