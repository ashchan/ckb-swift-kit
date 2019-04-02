//
//  Script.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Script: Codable, Param {
    public let version: UInt8
    public let args: [HexString]
    public var binaryHash: H256

    enum CodingKeys: String, CodingKey {
        case version, args
        case binaryHash = "binary_hash"
    }

    static let alwaysSuccessHash: H256 = "0000000000000000000000000000000000000000000000000000000000000001"
    public static var alwaysSuccess: Script {
        return Script(version: 0, args: [], binaryHash: alwaysSuccessHash)
    }

    public var typeHash: String {
        var bytes = [UInt8]()
        bytes.append(contentsOf: Data(hex: binaryHash).bytes)
        args.forEach { (arg) in
            bytes.append(contentsOf: Data(hex: arg).bytes)
        }
        let hash = Blake2b().hash(bytes: bytes)!
        return Utils.prefixHex(Data(hash).toHexString())
    }

    public var param: [String: Any] {
        return [
            CodingKeys.version.rawValue: version,
            CodingKeys.args.rawValue: args,
            CodingKeys.binaryHash.rawValue: binaryHash
        ]
    }

    public init(version: UInt8 = 0, args: [HexString] = [], binaryHash: H256 = H256.zeroHash) {
        self.version = version
        self.args = args
        self.binaryHash = binaryHash
    }
}

public extension Script {
    static func verifyScript(for publicKey: String, binaryHash: String) -> Script {
        let args = [
            Utils.prefixHex(publicKey.data(using: .utf8)!.toHexString())
            // Although public key itself is a hex string, when loaded as binary the format is ignored.
        ]
        return Script(
            version: 0,
            args: args,
            binaryHash: binaryHash
        )
    }
}
