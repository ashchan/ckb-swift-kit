//
//  TxPoolInfo.swift
//  CKB
//
//  Created by James Chen on 2019/05/08.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct TxPoolInfo: Codable {
    public let pending: UInt32
    public let staging: UInt32
    public let orphan: UInt32
    public let lastTxsUpdatedAt: Timestamp

    enum CodingKeys: String, CodingKey {
        case pending
        case staging
        case orphan
        case lastTxsUpdatedAt = "last_txs_updated_at"
    }
}
