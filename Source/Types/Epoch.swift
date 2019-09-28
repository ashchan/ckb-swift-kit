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
    public let compactTarget: UInt32 // TODO: Wait for CKB to update it to hex string

    enum CodingKeys: String, CodingKey {
        case number
        case startNumber = "start_number"
        case length
        case compactTarget = "compact_target"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        number = EpochNumber(hexString: try container.decode(String.self, forKey: .number))!
        startNumber = BlockNumber(hexString: try container.decode(String.self, forKey: .startNumber))!
        length = BlockNumber(hexString: try container.decode(String.self, forKey: .length))!
        compactTarget = try container.decode(UInt32.self, forKey: .compactTarget)
    }
}
