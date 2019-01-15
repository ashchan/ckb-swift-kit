//
//  Transaction.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Param {
    let version: UInt32
    let deps: [OutPoint]
    let inputs: [CellInput]
    let outputs: [CellOutput]
    let hash: H256

    public init(version: UInt32 = 0, deps: [OutPoint] = [], inputs: [CellInput] = [], outputs: [CellOutput] = [], hash: H256 = "") {
        self.version = version
        self.deps = deps
        self.inputs = inputs
        self.outputs = outputs
        self.hash = hash
    }

    public var param: [String: Any] {
        return [
            "version": version,
            "deps": deps.map { $0.param },
            "inputs": inputs.map { $0.param },
            "outputs": outputs.map { $0.param }
        ]
    }
}
