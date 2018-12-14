//
//  CellInput.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellInput: Codable {
    let previousOutput: OutPoint
    let unlock: Script

    enum CodingKeys: String, CodingKey {
        case previousOutput = "previous_output"
        case unlock
    }
}
