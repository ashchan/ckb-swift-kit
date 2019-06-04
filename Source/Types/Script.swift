//
//  Script.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Script: Codable, Param {
    public let args: [HexString]
    public var codeHash: H256

    enum CodingKeys: String, CodingKey {
        case args
        case codeHash = "code_hash"
    }

    public var hash: String {
        var bytes = [UInt8]()
        bytes.append(contentsOf: Data(hex: codeHash).bytes)
        args.forEach { (arg) in
            bytes.append(contentsOf: Data(hex: arg).bytes)
        }
        let hash = Blake2b().hash(bytes: bytes)!
        return Utils.prefixHex(Data(hash).toHexString())
    }

    public var param: [String: Any] {
        return [
            CodingKeys.args.rawValue: args,
            CodingKeys.codeHash.rawValue: codeHash
        ]
    }

    public init(args: [HexString] = [], codeHash: H256 = H256.zeroHash) {
        self.args = args
        self.codeHash = Utils.prefixHex(codeHash)
    }
}
