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

    /// Convert private key to public key.
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
            outPoint: OutPoint(hash: "0xfde51bd2a599de95c7d3353cad906d24da3db0e7840bdb4d405124d090098281", index: 0),
            cellHash: "0x6970dcf970e1a76aa6f493d69969a3c2455122e84dc6d1653a0dbcba465c330e"
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
