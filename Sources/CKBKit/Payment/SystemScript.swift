//
//  SystemScript.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import CKBFoundation

/// Provided by genesis block to unlock with the default secp256k1 algorithm.
public struct SystemScript {
    public let depOutPoint: OutPoint
    public let secp256k1TypeHash: H256

    public init(depOutPoint: OutPoint, secp256k1TypeHash: H256) {
        self.depOutPoint = depOutPoint
        self.secp256k1TypeHash = secp256k1TypeHash
    }

    public static func loadSystemScript() -> SystemScript {
        let depOutPoint = OutPoint(txHash: "0x71a7ba8fc96349fea0ed3a5c47992e3b4084b031a42264a018e0072e8172e46c", index: 0)
        let secp256k1TypeHash = "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8h"

        return SystemScript(depOutPoint: depOutPoint, secp256k1TypeHash: secp256k1TypeHash)
    }

    public func lock(for publicKey: Data) -> Script {
        let publicKeyHash = AddressGenerator.hash(for: publicKey).toHexString()
        return lock(for: publicKeyHash)
    }

    public func lock(for publicKeyHash: String) -> Script {
        return Script(args: Utils.prefixHex(publicKeyHash), codeHash: secp256k1TypeHash, hashType: .type)
    }
}
