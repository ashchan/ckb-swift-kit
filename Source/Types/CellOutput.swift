//
//  CellOutput.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellOutput: Codable, Param {
    public let capacity: Capacity
    public let lock: Script
    public let type: Script?

    public init(capacity: Capacity, lock: Script, type: Script? = nil) {
        self.capacity = capacity
        self.lock = lock
        self.type = type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        capacity = Capacity(hexValue: try container.decode(String.self, forKey: .capacity))!
        lock = try container.decode(Script.self, forKey: .lock)
        type = try container.decodeIfPresent(Script.self, forKey: .type)
    }

    public var param: [String: Any] {
        var result: [String: Any] = [
            "capacity": capacity.hexString,
            "lock": lock.param
        ]
        if let type = type {
            result["type"] = type.param
        }
        return result
    }
}

public struct CellOutputWithOutPoint: Codable {
    public let outPoint: OutPoint
    public let blockHash: H256
    public let capacity: Capacity
    public let lock: Script

    enum CodingKeys: String, CodingKey {
        case outPoint = "out_point"
        case blockHash = "block_hash"
        case capacity, lock
    }
}
