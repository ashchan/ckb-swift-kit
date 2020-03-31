//
//  PeerState.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct PeerState: Codable {
    public let peer: String
    public let lastUpdated: Date
    public let blocksInFlight: String

    enum CodingKeys: String, CodingKey {
        case peer
        case lastUpdated = "last_updated"
        case blocksInFlight = "blocks_in_flight"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        peer = try container.decode(String.self, forKey: .peer)
        lastUpdated = Date(hexSince1970: try container.decode(String.self, forKey: .lastUpdated))
        blocksInFlight = try container.decode(String.self, forKey: .blocksInFlight)
    }
}
