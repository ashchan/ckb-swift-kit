//
//  AddressGenerator.swift
//  CKB
//
//  Created by James Chen on 2019/04/10.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Address generator based on CKB Address Format [RFC](https://github.com/nervosnetwork/rfcs/blob/7f26d6528d770618a160e2856982221ec394749f/rfcs/0000-address-format/0000-address-format.md),
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
        return Bech32().encode(hrp: prefix, data: payload)
    }

    func hash(for publicKey: Data) -> Data {
        return blake160(publicKey)
    }

    private func blake160(_ data: Data) -> Data {
        return Blake2b().hash(data: data)!.prefix(upTo: 20)
    }
}
