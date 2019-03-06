//
//  Utils.swift
//  CKB
//
//  Created by James Chen on 2018/12/17.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Utils {
    public static func privateToPublic(_ privateKey: Data) -> Data {
        return Secp256k1.privateToPublic(privateKey: privateKey)
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
            outPoint: OutPoint(hash: "0x816c68f83e495a9e1ca083bcc81cefe4515a5e472d68909328db0a580979f538", index: 0),
            cellHash: "0x2165b10c4f6c55302158a17049b9dad4fef0acaf1065c63c02ddeccbce97ac47"
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
