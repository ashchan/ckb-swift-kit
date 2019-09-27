//
//  Script.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public enum ScriptHashType: String, Codable {
    case data
    case type
}

public struct Script: Codable, Param {
    public let codeHash: H256
    public let hashType: ScriptHashType
    public let args: HexString

    enum CodingKeys: String, CodingKey {
        case codeHash = "code_hash"
        case hashType = "hash_type"
        case args
    }

    public var param: [String: Any] {
        return [
            CodingKeys.args.rawValue: args,
            CodingKeys.codeHash.rawValue: codeHash,
            CodingKeys.hashType.rawValue: hashType.rawValue
        ]
    }

    public init(args: HexString = "0x", codeHash: H256 = H256.zeroHash, hashType: ScriptHashType = .data) {
        self.codeHash = Utils.prefixHex(codeHash)
        self.hashType = hashType
        self.args = args
    }
}
