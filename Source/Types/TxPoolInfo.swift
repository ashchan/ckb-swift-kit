//
//  TxPoolInfo.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct TxPoolInfo: Codable {
    public let pending: UInt64
    public let proposed: UInt64
    public let orphan: UInt64
    public let totalTxCycles: UInt64
    public let totalTxSize: UInt64
    public let lastTxsUpdatedAt: Timestamp

    enum CodingKeys: String, CodingKey {
        case pending
        case proposed
        case orphan
        case totalTxCycles = "total_tx_cycles"
        case totalTxSize = "total_tx_size"
        case lastTxsUpdatedAt = "last_txs_updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pending = UInt64(hexValue: try container.decode(String.self, forKey: .pending))!
        proposed = UInt64(hexValue: try container.decode(String.self, forKey: .proposed))!
        orphan = UInt64(hexValue: try container.decode(String.self, forKey: .orphan))!
        totalTxCycles = UInt64(hexValue: try container.decode(String.self, forKey: .totalTxCycles))!
        totalTxSize = UInt64(hexValue: try container.decode(String.self, forKey: .totalTxSize))!
        lastTxsUpdatedAt = try container.decode(Timestamp.self, forKey: .lastTxsUpdatedAt)
    }
}
