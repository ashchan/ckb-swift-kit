//
//  OutPoint.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct OutPoint: Codable {
    let hash: H256
    let index: UInt32

    var json: [String: Any] {
        return [
            "hash": hash,
            "index": index
        ]
    }
}
