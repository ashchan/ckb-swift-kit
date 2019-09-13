//
//  ChainInfo.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct ChainInfo: Codable {
    public let chain: String
    public let medianTime: Date
    public let epoch: EpochNumber
    public let difficulty: HexNumber
    public let isInitialBlockDownload: Bool
    public let alerts: [AlertMessage]

    enum CodingKeys: String, CodingKey {
        case chain
        case medianTime = "median_time"
        case epoch
        case difficulty
        case isInitialBlockDownload = "is_initial_block_download"
        case alerts
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chain = try container.decode(String.self, forKey: .chain)
        medianTime = Date(hexSince1970: try container.decode(String.self, forKey: .medianTime))
        epoch = EpochNumber(hexValue: try container.decode(String.self, forKey: .epoch))!
        difficulty = try container.decode(HexNumber.self, forKey: .difficulty)
        isInitialBlockDownload = try container.decode(Bool.self, forKey: .isInitialBlockDownload)
        alerts = try container.decode([AlertMessage].self, forKey: .alerts)
    }
}
