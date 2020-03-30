//
//  FeeRateResult.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct FeeRateResult: Codable {
    public let feeRate: UInt64

    enum CodingKeys: String, CodingKey {
        case feeRate = "fee_rate"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        feeRate = UInt64(hexString: try container.decode(String.self, forKey: .feeRate))!
    }
}
