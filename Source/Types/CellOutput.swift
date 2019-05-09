//
//  CellOutput.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellOutput: Codable, Param {
    public let capacity: Capacity
    public let data: HexString
    public let lock: Script
    public let type: Script?

    public init(capacity: Capacity, data: HexString, lock: Script, type: Script?) {
        self.capacity = capacity
        self.data = data
        self.lock = lock
        self.type = type
    }

    public var param: [String: Any] {
        var result: [String: Any] = [
            "capacity": capacity,
            "data": data,
            "lock": lock.param
        ]
        if let type = type {
            result["type"] = type
        }
        return result
    }
}

public struct CellOutputWithOutPoint: Codable {
    public let outPoint: OutPoint
    public let capacity: Capacity
    public let lock: Script

    enum CodingKeys: String, CodingKey {
        case outPoint = "out_point"
        case capacity, lock
    }
}
