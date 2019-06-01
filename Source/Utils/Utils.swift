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

    public static func publicToAddress(_ publicKey: String, network: Network = .testnet) -> String {
        let generator = AddressGenerator(network: network)
        return generator.address(for: publicKey)
    }

    public static func publicKeyHashToAddress(_ publicKeyHash: String, network: Network = .testnet) -> String {
        let generator = AddressGenerator(network: network)
        return generator.address(publicKeyHash: publicKeyHash)
    }

    public static func privateToAddress(_ privateKey: String, network: Network = .testnet) -> String {
        let publicKey = privateToPublic(privateKey)
        return publicToAddress(publicKey, network: network)
    }
}

extension Utils {
    public static func prefixHex(_ string: String) -> String {
        return string.hasPrefix("0x") ? string : "0x" + string
    }
}
