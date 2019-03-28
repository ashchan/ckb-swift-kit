//
//  Secp256k1.swift
//  CKB
//
//  Created by James Chen on 2019/03/02.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import secp256k1

/// Thin wrapper of [C Secp256k1 library](https://github.com/bitcoin-core/secp256k1).
final class Secp256k1 {
    /// Compute the public key for a secret key.
    /// - Parameters:
    ///   - privateKey: The 32-byte private key data.
    ///   - compressed: Specify if the public key should be compressed. Default is true.
    ///
    /// - Returns: The computed public key data. It's 33-byte if `compressed` is true, 65-byte otherwise.
    static func privateToPublic(privateKey: Data, compressed: Bool = true) -> Data {
        let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN))!
        defer {
            secp256k1_context_destroy(context)
        }

        let seckeyData = Array(privateKey)
        var publicKey = secp256k1_pubkey()
        _ = secp256k1_ec_pubkey_create(context, &publicKey, seckeyData)

        var length = compressed ? 33 : 65
        var data = Data(count: length)
        data.withUnsafeMutableBytes { (bytes: UnsafeMutableRawBufferPointer) in
            let flag = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
            let mutableBytes = bytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
            _ = secp256k1_ec_pubkey_serialize(context, mutableBytes, &length, &publicKey, flag)
        }
        return data
    }
}
