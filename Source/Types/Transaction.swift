//
//  Transaction.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct Transaction: Codable, Param {
    public let version: Version
    public let cellDeps: [CellDep]
    public let headerDeps: [H256]
    public let inputs: [CellInput]
    public let outputs: [CellOutput]
    public let outputsData: [HexString]
    public let witnesses: [Witness]
    public let hash: H256

    public init(
        version: Number = "0x0",
        cellDeps: [CellDep] = [],
        headerDeps: [H256] = [],
        inputs: [CellInput] = [],
        outputs: [CellOutput] = [],
        outputsData: [HexString] = [],
        witnesses: [Witness] = [],
        hash: H256 = ""
    ) {
        self.version = version
        self.cellDeps = cellDeps
        self.headerDeps = headerDeps
        self.inputs = inputs
        self.outputs = outputs
        self.outputsData = outputsData
        self.witnesses = witnesses
        self.hash = hash
    }

    enum CodingKeys: String, CodingKey {
        case version
        case cellDeps = "cell_deps"
        case headerDeps = "header_deps"
        case inputs
        case outputs
        case witnesses
        case outputsData = "outputs_data"
        case hash
    }

    public var param: [String: Any] {
        return [
            CodingKeys.version.rawValue: version,
            CodingKeys.cellDeps.rawValue: cellDeps.map { $0.param },
            CodingKeys.headerDeps.rawValue: headerDeps,
            CodingKeys.inputs.rawValue: inputs.map { $0.param },
            CodingKeys.outputs.rawValue: outputs.map { $0.param },
            CodingKeys.outputsData.rawValue: outputsData,
            CodingKeys.witnesses.rawValue: witnesses.map { $0.param }
        ]
    }
}

public struct TxStatus: Codable {
    public enum Status: String, Codable {
        case pending
        case proposed
        case committed
    }

    public let status: Status
    public let blockHash: H256?

    enum CodingKeys: String, CodingKey {
        case status
        case blockHash = "block_hash"
    }
}

public struct TransactionWithStatus: Codable {
    public let transaction: Transaction
    public let txStatus: TxStatus

    enum CodingKeys: String, CodingKey {
        case transaction
        case txStatus = "tx_status"
    }
}

public struct TransactionPoint: Codable {
    public let blockNumber: BlockNumber
    public let txHash: H256
    public let index: Number

    enum CodingKeys: String, CodingKey {
        case blockNumber = "block_number"
        case txHash = "tx_hash"
        case index
    }
}

public struct CellTransaction: Codable {
    public let createdBy: TransactionPoint
    public let consumedBy: TransactionPoint?

    enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case consumedBy = "consumed_by"
    }
}
