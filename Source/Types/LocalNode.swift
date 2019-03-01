//
//  LocalNode.swift
//  CKB
//
//  Created by James Chen on 2019/03/01.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct NodeAddress: Codable {
    let address: String
    let score: UInt8
}

public struct LocalNode: Codable {
    let version: String
    let nodeId: String
    let addresses: [NodeAddress]

    enum CodingKeys: String, CodingKey {
        case version
        case nodeId = "node_id"
        case addresses
    }
}
