//
//  AddressGenerator.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Address generator based on CKB Address Format [RFC](https://github.com/nervosnetwork/rfcs/blob/master/rfcs/0021-ckb-address-format/0021-ckb-address-format.md).
/// Currently we implement the predefined format type 0x01(short version for locks with popular code_hash) and code hash index 0x00(SECP256K1 + blake160).
public class AddressGenerator {
    public init() {}

    func prefix(network: Network) -> String {
        switch network {
        case .testnet:
            return "ckt"
        default:
            return "ckb"
        }
    }

    public func publicKeyHash(for address: String) -> String? {
        guard let data = parse(address: address)?.data else {
            return nil
        }
        return Data(data.bytes.suffix(20)).toHexString()
    }

    public func address(for publicKey: String, network: Network = .testnet) -> String {
        return address(for: Data(hex: publicKey), network: network)
    }

    public func address(for publicKey: Data, network: Network = .testnet) -> String {
        return address(publicKeyHash: hash(for: publicKey), network: network)
    }

    public func address(publicKeyHash: String, network: Network = .testnet) -> String {
        return address(publicKeyHash: Data(hex: publicKeyHash), network: network)
    }

    public func address(publicKeyHash: Data, network: Network = .testnet) -> String {
        // Payload: type(01) | code hash index(00, P2PH) | pubkey blake160
        let type = Data([0x01])
        let codeHashIndex = Data([0x00])
        let payload = type + codeHashIndex + publicKeyHash
        return Bech32().encode(hrp: prefix(network: network), data: convertBits(data: payload, fromBits: 8, toBits: 5, pad: true)!)
    }

    public func hash(for publicKey: Data) -> Data {
        return blake160(publicKey)
    }

    private func parse(address: String) -> (hrp: String, data: Data)? {
        if let parsed = Bech32().decode(bech32: address) {
            if let data = convertBits(data: parsed.data, fromBits: 5, toBits: 8, pad: false) {
                return (hrp: parsed.hrp, data: data)
            }
        }

        return nil
    }

    private func blake160(_ data: Data) -> Data {
        return Blake2b().hash(data: data)!.prefix(upTo: 20)
    }
}

extension AddressGenerator {
    private func convertBits(data: Data, fromBits: Int, toBits: Int, pad: Bool) -> Data? {
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
