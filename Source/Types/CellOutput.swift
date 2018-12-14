//
//  CellOutput.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellOutput: Codable {
    let capacity: Capacity
    let data: [UInt8]
    let lock: H256
    let contract: Script?
}

public struct CellOutputWithOutPoint: Codable {
    let outpoint: OutPoint
    let capacity: Capacity
    let lock: H256
}
