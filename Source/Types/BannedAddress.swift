//
//  BannedAddress.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct BannedAddress: Codable {
    public let address: String
    public let banReason: String
    public let banUntil: Timestamp
    public let createdAt: Timestamp

    enum CodingKeys: String, CodingKey {
        case address
        case banReason = "ban_reason"
        case banUntil = "ban_until"
        case createdAt = "created_at"
    }
}
