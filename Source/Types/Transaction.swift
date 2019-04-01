//
//  Transaction.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Param {
    public let version: UInt32
    public let deps: [OutPoint]
    public let inputs: [CellInput]
    public let outputs: [CellOutput]
    public let witnesses: [Witness]
    public let hash: H256

    public init(
        version: UInt32 = 0,
        deps: [OutPoint] = [],
        inputs: [CellInput] = [],
        outputs: [CellOutput] = [],
        witnesses: [Witness] = [],
        hash: H256 = ""
    ) {
        self.version = version
        self.deps = deps
        self.inputs = inputs
        self.outputs = outputs
        self.witnesses = witnesses
        self.hash = hash
    }

    public var param: [String: Any] {
        return [
            "version": version,
            "deps": deps.map { $0.param },
            "inputs": inputs.map { $0.param },
            "outputs": outputs.map { $0.param },
            "witnesses": witnesses.map { $0.param }
        ]
    }
}
