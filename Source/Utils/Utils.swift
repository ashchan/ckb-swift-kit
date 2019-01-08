//
//  Utils.swift
//  CKB
//
//  Created by James Chen on 2018/12/17.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation
import secp256k1_swift
import CryptoSwift

public struct Utils {
    public static func privateToPublic(_ privateKey: Data) -> Data {
        return SECP256K1.privateToPublic(privateKey: privateKey, compressed: true)!
    }

    /// Generate compressed public key from private key.
    ///
    /// - Parameters:
    ///   - privateKey: 64-char hex string.
    /// - Returns: Public key as hex string.
    public static func privateToPublic(_ privateKey: String) -> String {
        let publicKey = privateToPublic(Data(hex: privateKey))
        return publicKey.toHexString()
    }

    public static func publicToAddress(_ publicKey: String) -> String {
        let api = APIClient()
        // TODO: provide a way to set/load mruby contract cell
        api.setMrubyConfig(
            outPoint: OutPoint(hash: "0x5fd07886b1f08456d00c09d2330645994c547fdccc50c2fe8568327ae71c89fc", index: 0),
            cellHash: "0x4318dc7651886873ed1c7465b69878b22207f41901001824f30e5f7cf19db5f4"
        )
        return api.verifyScript(for: publicKey).typeHash
    }

    public static func privateToAddress(_ privateKey: String) -> String {
        let publicKey = privateToPublic(privateKey)
        return publicToAddress(publicKey)
    }
}

extension Utils {
    static func prefixHex(_ string: String) -> String {
        return "0x" + string
    }
}
