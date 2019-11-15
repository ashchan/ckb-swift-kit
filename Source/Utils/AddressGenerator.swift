//
//  AddressGenerator.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

// Based on CKB Address Format [RFC](https://github.com/nervosnetwork/rfcs/blob/master/rfcs/0021-ckb-address-format/0021-ckb-address-format.md).

public enum AddressPlayloadFormatType: UInt8 {
    case short = 0x01     // short version for locks with popular code_hash
    case fullData = 0x02  // full version with hash_type = "Data"
    case fullType = 0x04  // full version with hash_type = "Type"
}

/// Code hash index for Short Payload Format
public enum AddressCodeHashIndex: UInt8 {
    case secp256k1Blake160 = 0x00
    case secp256k1Multisig = 0x01
}

/// Nervos CKB Address generator.
/// Currently only the short version lock for SECP256K1 + blake160 is implemented.
/// Format type is 0x01 and code hash index is 0x00.
public class AddressGenerator {
    static func prefix(network: Network) -> String {
        switch network {
        case .testnet:
            return "ckt"
        default:
            return "ckb"
        }
    }

    public static func publicKeyHash(for address: String) -> String? {
        guard let data = parse(address: address)?.data else {
            return nil
        }
        return Data(data.bytes.suffix(20)).toHexString()
    }

    public static func address(for publicKey: String, network: Network = .testnet) -> String {
        return address(for: Data(hex: publicKey), network: network)
    }

    public static func address(for publicKey: Data, network: Network = .testnet) -> String {
        return address(publicKeyHash: hash(for: publicKey), network: network)
    }

    public static func address(publicKeyHash: String, network: Network = .testnet) -> String {
        return address(publicKeyHash: Data(hex: publicKeyHash), network: network)
    }

    public static func address(publicKeyHash: Data, network: Network = .testnet) -> String {
        let type = Data([AddressPlayloadFormatType.short.rawValue])
        let codeHashIndex = Data([AddressCodeHashIndex.secp256k1Blake160.rawValue])
        let payload = type + codeHashIndex + publicKeyHash
        return Bech32().encode(hrp: prefix(network: network), data: convertBits(data: payload, fromBits: 8, toBits: 5, pad: true)!)
    }

    public static func hash(for publicKey: Data) -> Data {
        return blake160(publicKey)
    }
}

public extension AddressGenerator {
    static func validate(_ address: String) -> Bool {
        guard let (hlp, _) = parse(address: address) else {
            return false
        }

        return [prefix(network: .mainnet), prefix(network: .testnet)].contains(hlp)
    }
}

private extension AddressGenerator {
    static func parse(address: String) -> (hrp: String, data: Data)? {
        if let parsed = Bech32().decode(bech32: address) {
            if let data = convertBits(data: parsed.data, fromBits: 5, toBits: 8, pad: false) {
                let payload = data.bytes
                if payload.count != 22 {
                    return nil
                }
                guard let format = AddressPlayloadFormatType(rawValue: payload[0]), format == .short else {
                    return nil
                }
                guard let codeHashIndex = AddressCodeHashIndex(rawValue: payload[1]), codeHashIndex == .secp256k1Blake160 else {
                    return nil
                }
                return (hrp: parsed.hrp, data: data)
            }
        }

        return nil
    }

    static func blake160(_ data: Data) -> Data {
        return Blake2b().hash(data: data)!.prefix(upTo: 20)
    }

    static func convertBits(data: Data, fromBits: Int, toBits: Int, pad: Bool) -> Data? {
        var ret = Data()
        var acc = 0
        var bits = 0
        let maxv = (1 << toBits) - 1
        for p in 0..<data.count {
            let value = data[p]
            if value < 0 || (value >> fromBits) != 0 {
                return nil
            }
            acc = (acc << fromBits) | Int(value)
            bits += fromBits
            while bits >= toBits {
                bits -= toBits
                ret.append(UInt8((acc >> bits) & maxv))
            }
        }
        if pad {
            if bits > 0 {
                ret.append(UInt8((acc << (toBits - bits)) & maxv))
            }
        } else if bits >= fromBits || ((acc << (toBits - bits)) & maxv) > 0 {
            return nil
        }
        return ret
    }
}
