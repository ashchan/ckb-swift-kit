//
//  CellDep.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public enum DepType: String, Codable {
    case code
    case depGroup = "dep_group"
}

public struct CellDep: Codable, Param {
    public let outPoint: OutPoint
    public let depType: DepType

    public init(outPoint: OutPoint, depType: DepType = .code) {
        self.outPoint = outPoint
        self.depType = depType
    }

    enum CodingKeys: String, CodingKey {
        case outPoint = "out_point"
        case depType = "dep_type"
    }

    public var param: [String: Any] {
        return [
            CodingKeys.outPoint.rawValue: outPoint.param,
            CodingKeys.depType.rawValue: depType.rawValue
        ]
    }
}
