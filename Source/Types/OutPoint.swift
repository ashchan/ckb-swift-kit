//
//  OutPoint.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct OutPoint: Codable, Param {
    public let txHash: H256
    public let index: UInt32

    enum CodingKeys: String, CodingKey {
        case txHash = "tx_hash"
        case index
    }

    public init(txHash: H256, index: UInt32) {
        self.txHash = txHash
        self.index = index
    }

    public var param: [String: Any] {
        return [
            "tx_hash": txHash,
            "index": index
        ]
    }
}
