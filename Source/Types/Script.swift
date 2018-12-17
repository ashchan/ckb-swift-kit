//
//  Script.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Script: Codable, Param {
    let version: UInt8
    let args: [[UInt8]]
    var reference: H256?
    var binary: [UInt8]?
    let signedArgs: [[UInt8]]

    enum CodingKeys: String, CodingKey {
        case version, args, reference, binary
        case signedArgs = "signed_args"
    }

    public var param: [String: Any] {
        var result: [String: Any] = [
            "version": version,
            "args": args,
            CodingKeys.signedArgs.rawValue: signedArgs
        ]
        if let reference = reference {
            result["reference"] = reference
        }
        if let binary = binary {
            result["binary"] = binary
        }
        return result
    }
}
