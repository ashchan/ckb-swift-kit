//
//  Script.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Script: Codable {
    let version: UInt8
    let args: [[UInt8]]
    var reference: H256?
    var binary: [UInt8]?
    let signedArgs: [[UInt8]]

    enum CodingKeys: String, CodingKey {
        case version, args, reference, binary
        case signedArgs = "signed_args"
    }
}
