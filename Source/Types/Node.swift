//
//  Node.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct NodeAddress: Codable {
    public let address: String
    public let score: UInt64

    enum CodingKeys: String, CodingKey {
        case address, score
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        score = UInt64(hexValue: try container.decode(String.self, forKey: .score))!
    }
}

public struct Node: Codable {
    public let version: String
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
