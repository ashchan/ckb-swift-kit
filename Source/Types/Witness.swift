//
//  Witness.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Witness: Codable, Param {
    public let data: [HexString]

    public init(data: [HexString] = []) {
        self.data = data
    }

    public var param: [String: Any] {
        return [
            "data": data
        ]
    }
}
