//
//  AddressGenerator.swift
//  CKB
//
//  Created by James Chen on 2019/04/10.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Address generator based on CKB Address Format [RFC](https://github.com/nervosnetwork/rfcs/blob/4f87099a0b1a02a8bc077fc7bea15ce3d9def120/rfcs/0000-address-format/0000-address-format.md),
/// and [Common Address Format](https://github.com/nervosnetwork/ckb/wiki/Common-Address-Format).
class AddressGenerator {
    let network: Network

    init(network: Network = .testnet) {
        self.network = network
    }

    var prefix: String {
        switch network {
        case .testnet:
            return "ckt"
        default:
            return "ckb"
        }
    }

    func address(for publicKey: String) -> String {
        return address(for: Data(hex: publicKey))
    }

    func address(for publicKey: Data) -> String {
        // Payload: type(01) | bin-idx("P2PH") | pubkey blake160
        let type = Data([0x01])
        let binIdx = "P2PH".data(using: .ascii)!
        let payload = type + binIdx + hash(for: publicKey)
        return Bech32().encode(hrp: prefix, data: convertBits(data: payload, fromBits: 8, toBits: 5, pad: true)!)
    }

    func hash(for publicKey: Data) -> Data {
        return blake160(publicKey)
    }

    func parse(address: String) -> (hrp: String, data: Data)? {
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
