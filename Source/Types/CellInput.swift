//
//  CellInput.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellInput: Codable, Param {
    public let previousOutput: OutPoint
    public let since: UInt64

    public init(previousOutput: OutPoint, since: UInt64) {
        self.previousOutput = previousOutput
        self.since = since
    }

    enum CodingKeys: String, CodingKey {
        case previousOutput = "previous_output"
        case since
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        previousOutput = try container.decode(OutPoint.self, forKey: .previousOutput)
        since = UInt64(hexValue: try container.decode(String.self, forKey: .since))!
    }

    public var param: [String: Any] {
        return [
            CodingKeys.previousOutput.rawValue: previousOutput.param,
            CodingKeys.since.rawValue: since.hexString
        ]
    }
}
