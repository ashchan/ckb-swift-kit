//
//  AlertMessage.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct AlertMessage: Codable {
    public let id: String
    public let priority: String
    public let noticeUntil: Date
    public let message: String

    enum CodingKeys: String, CodingKey {
        case id
        case priority
        case noticeUntil = "notice_until"
        case message
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        priority = try container.decode(String.self, forKey: .priority)
        noticeUntil = Date(hexSince1970: try container.decode(String.self, forKey: .noticeUntil))
        message = try container.decode(String.self, forKey: .message)
    }
}
