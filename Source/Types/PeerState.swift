//
//  PeerState.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct PeerState: Codable {
    public let peer: String
    public let lastUpdated: Timestamp
    public let blocksInFlight: String

    enum CodingKeys: String, CodingKey {
        case peer
        case lastUpdated = "last_updated"
        case blocksInFlight = "blocks_in_flight"
    }
}
