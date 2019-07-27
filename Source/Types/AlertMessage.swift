//
//  AlertMessage.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct AlertMessage: Codable {
    public let id: String
    public let priority: String
    public let noticeUntil: Timestamp
    public let message: String

    enum CodingKeys: String, CodingKey {
        case id
        case priority
        case noticeUntil = "notice_until"
        case message
    }
}
