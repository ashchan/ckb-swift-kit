//
//  CellDep.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellDep: Codable, Param {
    public let outPoint: OutPoint
    public let isDepGroup: Bool

    public init(outPoint: OutPoint, isDepGroup: Bool = false) {
        self.outPoint = outPoint
        self.isDepGroup = isDepGroup
    }

    enum CodingKeys: String, CodingKey {
        case outPoint = "out_point"
        case isDepGroup = "is_dep_group"
    }

    public var param: [String: Any] {
        return [
            CodingKeys.outPoint.rawValue: outPoint.param,
            CodingKeys.isDepGroup.rawValue: isDepGroup
        ]
    }
}
