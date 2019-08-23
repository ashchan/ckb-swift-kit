//
//  Script.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public enum ScriptHashType: String, Codable {
    case data = "Data"
    case type = "Type"
}

public struct Script: Codable, Param {
    public let args: [HexString]
    public let codeHash: H256
    public let hashType: ScriptHashType

    enum CodingKeys: String, CodingKey {
        case args
        case codeHash = "code_hash"
        case hashType = "hash_type"
    }

    // Before serialization is implemented _compute_script_hash RPC should be used instead.
    public var hash: String {
        #warning("This needs re-implementation when serialization is applied.")
        var bytes = [UInt8]()
        bytes.append(contentsOf: Data(hex: codeHash).bytes)
        bytes.append(hashType == .data ? 0x0 : 0x1)
        args.forEach { (arg) in
            bytes.append(contentsOf: Data(hex: arg).bytes)
        }
        let hash = Blake2b().hash(bytes: bytes)!
        return Utils.prefixHex(Data(hash).toHexString())
    }

    public var param: [String: Any] {
        return [
            CodingKeys.args.rawValue: args,
            CodingKeys.codeHash.rawValue: codeHash,
            CodingKeys.hashType.rawValue: hashType.rawValue
        ]
    }

    public init(args: [HexString] = [], codeHash: H256 = H256.zeroHash, hashType: ScriptHashType = .data) {
        self.args = args
        self.codeHash = Utils.prefixHex(codeHash)
        self.hashType = hashType
    }
}
