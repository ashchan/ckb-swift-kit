//
//  Blake2b.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Cblake2b

// Blake2b-256 Hash, with CKB's personalization.
public final class Blake2b {
    public init() {}

    public func hash(data: Data) -> Data? {
        return hash(bytes: data.bytes)
    }

    public func hash(bytes: [UInt8]) -> Data? {
        let outputLength = Int(32)
        var output = [UInt8](repeating: 0, count: outputLength)

        guard 0 == blake2b(
            &output,
            outputLength,
            bytes,
            (bytes.count),
            nil,
            0
        ) else { return nil }

        return Data(output)
    }

    // Hash and return H256 hex string
    public func hash(bytes: [UInt8]) -> H256 {
        let hashed = Blake2b().hash(bytes: bytes)!.toHexString()
        return Utils.prefixHex(hashed)
    }
}
