//
//  Script.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Script: Codable, Param {
    /// Used to resolve incompatible upgrades.
    let version: UInt8
    /// ELF formatted binary containing the actual RISC-V based contract.
    var binary: HexString?
    /// If your contract already exists on CKB, you can use this field to reference the contract instead of including it again.
    /// You can just put the script hash(will explain later how this is calculated) in this reference field, then list the cell containing the contract as a dep in current transaction.
    /// CKB would automatically locate cell, load the binary from there and use it as script binary part.
    /// Notice this only works when you don't provide a binary field value, otherwise the value in binary field always take precedence.
    var reference: H256?
    let signedArgs: [HexString]
    let args: [HexString]

    enum CodingKeys: String, CodingKey {
        case version, args, reference, binary
        case signedArgs = "signed_args"
    }

    public var typeHash: String {
        var bytes = [UInt8]()
        if let reference = reference {
            bytes.append(contentsOf: Data(hex: reference).bytes)
        }
        bytes.append(contentsOf: "|".data(using: .utf8)!.bytes)
        if let binary = binary {
            bytes.append(contentsOf: Data(hex: binary).bytes)
        }
        signedArgs.forEach { (arg) in
            bytes.append(contentsOf: Data(hex: arg).bytes)
        }
        let hash = Blake2b().hash(bytes: bytes)!
        return Utils.prefixHex(Data(bytes: hash).toHexString())
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
