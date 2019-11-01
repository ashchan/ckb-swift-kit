//
//  WitnessArgs.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public enum WitnessArgs {
    case data(String) // Raw data as hex string
    case parsed(String, String, String) // lock, inputType, outputType

    public static let emptyLockHash = [String](repeating: "00", count: 65).joined()

    public static let emptyLock: WitnessArgs = .parsed(Utils.prefixHex(emptyLockHash), "0x", "0x")
}
