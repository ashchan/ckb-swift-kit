//
//  OutPoint.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct OutPoint: Codable, Param {
    let hash: H256
    let index: UInt32

    public init(hash: String, index: UInt32) {
        self.hash = hash
        self.index = index
    }

    public var param: [String: Any] {
        return [
            "hash": hash,
            "index": index
        ]
    }
}
