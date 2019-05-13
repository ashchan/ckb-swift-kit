//
//  ChainInfo.swift
//  CKB
//
//  Created by James Chen on 2019/05/09.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct ChainInfo: Codable {
    public let chain: String
    public let medianTime: Timestamp
    public let epoch: EpochNumber
    public let difficulty: HexNumber
    public let isInitialBlockDownload: Bool
    public let warnings: String

    enum CodingKeys: String, CodingKey {
        case chain
        case medianTime = "median_time"
        case epoch
        case difficulty
        case isInitialBlockDownload = "is_initial_block_download"
        case warnings
    }
}
