//
//  LocalNode.swift
//  CKB
//
//  Created by James Chen on 2019/03/01.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct NodeAddress: Codable {
    public let address: String
    public let score: UInt8
}

public struct LocalNode: Codable {
    public let version: String
    public let nodeId: String
    public let addresses: [NodeAddress]

    enum CodingKeys: String, CodingKey {
        case version
        case nodeId = "node_id"
        case addresses
    }
}
