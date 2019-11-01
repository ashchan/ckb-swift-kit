//
//  WitnessArgs.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct WitnessArgs {
    public let lock: String
    public let inputType: String
    public let outputType: String

    public static let emptyLock: WitnessArgs = {
        let lock = [String](repeating: "00", count: 65).joined()
        return WitnessArgs(lock: Utils.prefixHex(lock))
    }()

    public init(lock: String = "0x", inputType: String = "0x", outputType: String = "0x") {
        self.lock = lock
        self.inputType = inputType
        self.outputType = outputType
    }
}
