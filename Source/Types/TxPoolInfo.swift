//
//  TxPoolInfo.swift
//  CKB
//
//  Created by James Chen on 2019/05/08.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct TxPoolInfo: Codable {
    public let pending: Number
    public let proposed: Number
    public let orphan: Number
    public let lastTxsUpdatedAt: Timestamp

    enum CodingKeys: String, CodingKey {
        case pending
        case proposed
        case orphan
        case lastTxsUpdatedAt = "last_txs_updated_at"
    }
}
