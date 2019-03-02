//
//  Secp256k1.swift
//  CKB
//
//  Created by James Chen on 2019/03/02.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import secp256k1

final class Secp256k1 {
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
        data.withUnsafeMutableBytes { (bytes: UnsafeMutablePointer<UInt8>) in
            let flag = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
            _ = secp256k1_ec_pubkey_serialize(context, bytes, &length, &publicKey, flag)
        }
        return data
    }
}
