//
//  TxPoolInfo.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct TxPoolInfo: Codable {
    public let pending: Number
    public let proposed: Number
    public let orphan: Number
    public let totalTxCycles: Number
    public let totalTxSize: Number
    public let lastTxsUpdatedAt: Timestamp

    enum CodingKeys: String, CodingKey {
        case pending
        case proposed
        case orphan
        case totalTxCycles = "total_tx_cycles"
        case totalTxSize = "total_tx_size"
        case lastTxsUpdatedAt = "last_txs_updated_at"
    }
}
