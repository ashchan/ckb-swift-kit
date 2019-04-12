//
//  Witness.swift
//  CKB
//
//  Created by James Chen on 2019/04/01.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Witness: Codable, Param {
    public let data: [HexString]

    public var param: [String: Any] {
        return [
            "data": data
        ]
    }
}
