//
//  Secp256k1.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import secp256k1

/// Thin wrapper of [C Secp256k1 library](https://github.com/bitcoin-core/secp256k1).
final public class Secp256k1 {
    private let context: OpaquePointer
    public static let shared = Secp256k1()

    private init() {
        context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN) | UInt32(SECP256K1_CONTEXT_VERIFY))!
    }

    deinit {
        secp256k1_context_destroy(context)
    }

    /// Compute the public key for a secret key.
    /// - Parameters:
    ///   - privateKey: The 32-byte private key data.
    ///   - compressed: Specify if the public key should be compressed. Default is true.
    ///
    /// - Returns: The computed public key data. It's 33-byte if `compressed` is true, 65-byte otherwise.
    public func privateToPublic(privateKey: Data, compressed: Bool = true) -> Data {
        let seckeyData = Array(privateKey)
        var publicKey = secp256k1_pubkey()
        _ = secp256k1_ec_pubkey_create(context, &publicKey, seckeyData)
        return serializePublicKey(pubkey: &publicKey, compressed: compressed)
    }

    /// ECDSA sign message with secret key.
    /// - Parameters:
    ///   - privateKey: The 32-byte private key data.
    ///   - data: The message to sign.
    ///
    /// - Returns: The ECDSA signature. If the signing is not successful returns nil.
    public func sign(privateKey: Data, data: Data) -> Data? {
        var signature: secp256k1_ecdsa_signature = secp256k1_ecdsa_signature()
        let result = data.withUnsafeBytes { (data: UnsafeRawBufferPointer) -> Int32 in
            privateKey.withUnsafeBytes { (privateKey: UnsafeRawBufferPointer) in
                withUnsafeMutablePointer(to: &signature, {
                    let dataPointer = data.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    let privateKeyPointer = privateKey.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return secp256k1_ecdsa_sign(context, $0, dataPointer, privateKeyPointer, nil, nil)
                })
            }
        }
        guard result == 1 else {
            return nil
        }

        return serializeSignature(signature: &signature)
    }

    /// ECDSA recoverable sign message with secret key.
    /// - Parameters:
    ///   - privateKey: The 32-byte private key data.
    ///   - data: The message to sign.
    ///
    /// - Returns: The recoverable ECDSA signature. If the signing is not successful returns nil.
    public func signRecoverable(privateKey: Data, data: Data) -> Data? {
        var signature: secp256k1_ecdsa_recoverable_signature = secp256k1_ecdsa_recoverable_signature()
        let result = data.withUnsafeBytes { (data: UnsafeRawBufferPointer) -> Int32 in
            privateKey.withUnsafeBytes { (privateKey: UnsafeRawBufferPointer) in
                withUnsafeMutablePointer(to: &signature, {
                    let dataPointer = data.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    let privateKeyPointer = privateKey.baseAddress!.assumingMemoryBound(to: UInt8.self)
                    return secp256k1_ecdsa_sign_recoverable(
                        context,
                        $0,
                        dataPointer,
                        privateKeyPointer,
                        nil,
                        nil
                    )
                })
            }
        }
        guard result == 1 else {
            return nil
        }

        return serializeRecoverableSignature(signature: &signature)
    }

    func serializeRecoverableSignature(signature: inout secp256k1_ecdsa_recoverable_signature) -> Data? {
        let length = 64
        var serialized = Data(count: length)
        var result: Int32 = 0
        var recid: Int32 = 0
        serialized.withUnsafeMutableBytes {
            let mutableBytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            result = secp256k1_ecdsa_recoverable_signature_serialize_compact(context, mutableBytes, &recid, &signature)
        }
        guard result == 1 else {
            return nil
        }

        return serialized.prefix(length) + Data([UInt8(recid)])
    }

    func serializeSignature(signature: inout secp256k1_ecdsa_signature) -> Data? {
        var length = 74
        var serialized = Data(count: length)
        var result: Int32 = 0
        serialized.withUnsafeMutableBytes {
            let mutableBytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            result = secp256k1_ecdsa_signature_serialize_der(context, mutableBytes, &length, &signature)
        }
        guard result == 1 else {
            return nil
        }

        return serialized.prefix(length)
    }

    func serializePublicKey(pubkey: UnsafePointer<secp256k1_pubkey>, compressed: Bool = true) -> Data {
        var length = compressed ? 33 : 65
        var data = Data(count: length)
        let flag = compressed ? UInt32(SECP256K1_EC_COMPRESSED) : UInt32(SECP256K1_EC_UNCOMPRESSED)
        data.withUnsafeMutableBytes {
            let mutableBytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            _ = secp256k1_ec_pubkey_serialize(context, mutableBytes, &length, pubkey, flag)
        }
        return data
    }

    func parsePublicKey(publicKey: Data) -> secp256k1_pubkey? {
        let len = publicKey.count
        guard len == 33 || len == 65 else {
            return nil
        }
        var pub = secp256k1_pubkey()
        let result = secp256k1_ec_pubkey_parse(context, &pub, publicKey.bytes, len)
        return result == 0 ? nil: pub
   }

    public func seckeyTweakAdd(privateKey: Data, tweak: Data) -> Data? {
        var data = privateKey
        data.withUnsafeMutableBytes {
            let mutableBytes = $0.baseAddress!.assumingMemoryBound(to: UInt8.self)
            _ = secp256k1_ec_seckey_tweak_add(context, mutableBytes, Array(tweak))
        }
        return data
    }

    public func pubkeyTweakAdd(publicKey: Data, tweak: Data) -> Data? {
        var pubkey = parsePublicKey(publicKey: publicKey)!
        _ = secp256k1_ec_pubkey_tweak_add(context, &pubkey, Array(tweak))
        return serializePublicKey(pubkey: &pubkey, compressed: true)
    }
}
