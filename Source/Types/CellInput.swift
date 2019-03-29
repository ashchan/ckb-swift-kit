//
//  CellInput.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellInput: Codable, Param {
    public let previousOutput: OutPoint
    public let args: [HexString]

    public init(previousOutput: OutPoint, args: [HexString]) {
        self.previousOutput = previousOutput
        self.args = args
    }

    enum CodingKeys: String, CodingKey {
        case previousOutput = "previous_output"
        case args
    }

    public var param: [String: Any] {
        return [
            CodingKeys.previousOutput.rawValue: previousOutput.param,
            CodingKeys.args.rawValue: args
        ]
    }
}
