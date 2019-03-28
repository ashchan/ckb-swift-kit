//
//  Utils.swift
//  CKB
//
//  Created by James Chen on 2018/12/17.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Utils {
    public static func generatePrivateKey() -> String {
        var data = Data(repeating: 0, count: 32)
        data.withUnsafeMutableBytes({ _ = SecRandomCopyBytes(kSecRandomDefault, 32, $0.baseAddress!) })
        return data.toHexString()
    }

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
            outPoint: OutPoint(hash: "0x765273ea8ca662eb38c66b307779968a031cf5242f72972a7352dbaed6e9fecb", index: 0),
            cellHash: "0x828d1e109a79964521bf5fbbedb4f6e695a9c4b6b674a58887f30c7398e93a76"
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
