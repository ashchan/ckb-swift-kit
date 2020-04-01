//
//  Utils.swift
//
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

    public static func publicToAddress(_ publicKey: String, network: Network = .mainnet) -> String {
        return AddressGenerator.address(for: publicKey, network: network)
    }

    public static func publicKeyHashToAddress(_ publicKeyHash: String, network: Network = .mainnet) -> String {
        return AddressGenerator.address(publicKeyHash: publicKeyHash, network: network)
    }

    public static func privateToAddress(_ privateKey: String, network: Network = .mainnet) -> String {
        let publicKey = privateToPublic(privateKey)
        return publicToAddress(publicKey, network: network)
    }
}

extension Utils {
    public static func prefixHex(_ string: String) -> String {
        return string.hasPrefix("0x") ? string : "0x" + string
    }

    public static func removeHexPrefix(_ string: String) -> String {
        return string.hasPrefix("0x") ? String(string.dropFirst(2)) : string
    }
}
