//
//  CellInput.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellInput: Codable, Param {
    public let previousOutput: OutPoint
    public let since: Number

    public init(previousOutput: OutPoint, since: Number) {
        self.previousOutput = previousOutput
        self.since = since
    }

    enum CodingKeys: String, CodingKey {
        case previousOutput = "previous_output"
        case since
    }

    public var param: [String: Any] {
        return [
            CodingKeys.previousOutput.rawValue: previousOutput.param,
            CodingKeys.since.rawValue: since
        ]
    }
}
