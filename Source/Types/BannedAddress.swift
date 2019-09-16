//
//  BannedAddress.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct BannedAddress: Codable {
    public let address: String
    public let banReason: String
    public let banUntil: Date
    public let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case address
        case banReason = "ban_reason"
        case banUntil = "ban_until"
        case createdAt = "created_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        banReason = try container.decode(String.self, forKey: .banReason)
        banUntil = Date(hexSince1970: try container.decode(String.self, forKey: .banUntil))
        createdAt = Date(hexSince1970: try container.decode(String.self, forKey: .createdAt))
    }
}
