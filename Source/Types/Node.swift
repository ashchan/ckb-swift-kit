//
//  Node.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct NodeAddress: Codable {
    public let address: String
    public let score: Number
}

public struct Node: Codable {
    public let version: Version
    public let nodeId: String
    public let addresses: [NodeAddress]
    public let isOutbound: Bool?

    enum CodingKeys: String, CodingKey {
        case version
        case nodeId = "node_id"
        case addresses
        case isOutbound = "is_outbound"
    }
}
