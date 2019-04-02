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
        // TODO: save/load (cell) binary hash info
        let binaryHash = "0x828d1e109a79964521bf5fbbedb4f6e695a9c4b6b674a58887f30c7398e93a76"
        return Script.verifyScript(for: publicKey, binaryHash: binaryHash).typeHash
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
