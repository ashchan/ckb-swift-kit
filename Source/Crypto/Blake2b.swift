//
//  Blake2b.swift
//  CKB
//
//  Created by James Chen on 2019/03/06.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Sodium

// Blake2b-256 Hash
final class Blake2b {
    func hash(data: Data) -> Data? {
        return hash(bytes: data.bytes)
    }

    func hash(bytes: [UInt8]) -> Data? {
        let sodium = Sodium()
        if let hash = sodium.genericHash.hash(message: bytes) {
            return Data(bytes: hash)
        }
        return nil
    }
}
