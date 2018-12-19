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
        return typeHash(from: verifyScript(for: publicKey))
    }

    public static func privateToAddress(_ privateKey: String) -> String {
        let publicKey = privateToPublic(privateKey)
        return publicToAddress(publicKey)
    }

    static func verifyScript(for publicKey: String) -> Script {
        let client = APIClient()
        let signedArgs = [
            VerifyScript.script.content,
            publicKey.data(using: .utf8)!.bytes
        ]
        return Script(
            version: 0,
            binary: nil,
            reference: try! client.mrubyCellHash(),
            signedArgs: signedArgs,
            args: []
        )
    }

    static func typeHash(from script: Script) -> String {
        var sha3 = SHA3(variant: .sha256)
        if let reference = script.reference {
            _ = try! sha3.update(withBytes: Data(hex: reference).bytes)
        }
        _ = try! sha3.update(withBytes: "|".data(using: .utf8)!.bytes)
        if let binary = script.binary {
            _ = try! sha3.update(withBytes: binary)
        }
        script.signedArgs.forEach { (arg) in
            _ = try! sha3.update(withBytes: arg)
        }
        let hash = try! sha3.finish()
        return prefixHex(Data(bytes: hash).toHexString())
    }
}

extension Utils {
    static func prefixHex(_ string: String) -> String {
        return "0x" + string
    }
}
