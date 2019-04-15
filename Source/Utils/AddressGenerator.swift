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
        // TODO: implement bech32
        let bench32: (String, String) -> String = { prefix, payload in
            return prefix + payload
        }
        return bench32(prefix, "002" + hash(for: publicKey).toHexString())
    }

    func hash(for publicKey: Data) -> Data {
        return Blake2b().hash(data: publicKey)!
    }
}
