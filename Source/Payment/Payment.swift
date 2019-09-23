//
//  Payment.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public final class Payment {
    public static let minAmount = Capacity(61 * 100_000_000) // Assuming output data is `0x` and algorithm is the default Secp256k1

    private let fromPublicKeyHash: String
    private let toPublicKeyHash: String
    private let amount: Capacity
    private let fee: Capacity

    private let apiClient: APIClient

    public var signedTx: Transaction?
    /// Keep track of the block number around which this payment has scanned and stopped.
    public private(set) var lastBlockNumber: BlockNumber = 0
    public var unspentCellCollectorType: UnspentCellCollector.Type! = LiveCellCollector.self

    public init(from: String, to: String, amount: Capacity, fee: Capacity = 0, apiClient: APIClient) throws {
        guard let fromHash = AddressGenerator.publicKeyHash(for: from) else {
            throw Error.invalidFromAddress
        }
        fromPublicKeyHash = fromHash
        guard let toHash = AddressGenerator.publicKeyHash(for: to) else {
            throw Error.invalidToAddress
        }
        toPublicKeyHash = toHash

        guard amount >= Payment.minAmount else {
            throw Error.insufficientAmount
        }
        self.amount = amount

        self.fee = fee

        self.apiClient = apiClient
    }

    @discardableResult
    public func sign(privateKey: Data) throws -> Transaction? {
        let pubKeyHash = AddressGenerator.hash(for: Utils.privateToPublic(privateKey))
        guard pubKeyHash.toHexString() == fromPublicKeyHash else {
            throw Error.privateKeyAndAddressNotMatch
        }

        let tx = try generateTx()
        signedTx = try Transaction.sign(tx: tx, with: privateKey)
        return signedTx
    }

    public func send() throws -> H256 {
        guard let signedTx = signedTx else {
            throw Error.txNotSigned
        }
        _ = try apiClient.sendTransaction(transaction: signedTx)
        return signedTx.hash
    }

    private lazy var systemScript: SystemScript = {
        return try! SystemScript.loadSystemScript(apiClient: apiClient)
    }()
}

public extension Payment {
    enum Error: Swift.Error, LocalizedError {
        case invalidFromAddress
        case invalidToAddress
        case insufficientAmount
        case insufficientBalance
        case privateKeyAndAddressNotMatch
        case txNotSigned

        public var errorDescription: String? {
            switch self {
            case .invalidFromAddress:
                return "Invalid from address."
            case .invalidToAddress:
                return "Invalid to address."
            case .insufficientAmount:
                return "Insufficient Amount. Require at least \(Payment.minAmount) shannons."
            case .insufficientBalance:
                return "Insufficient balance to send out."
            case .privateKeyAndAddressNotMatch:
                return "The private key to sign the tx doesn't match the from address."
            case .txNotSigned:
                return "The tx hasn't been signed."
            }
        }
    }
}

private extension Payment {
    func generateTx() throws -> Transaction {
        let (inputs, changeAmount) = collectInputs()
        if inputs.count == 0 {
            throw Error.insufficientBalance
        }

        var outputs = [CellOutput(capacity: amount, lock: systemScript.lock(for: toPublicKeyHash))]
        if changeAmount > 0 {
            outputs.append(CellOutput(capacity: changeAmount, lock: systemScript.lock(for: fromPublicKeyHash)))
        }

        return Transaction(
            version: 0,
            cellDeps: [cellDep],
            inputs: inputs,
            outputs: outputs,
            outputsData: outputs.map { _ in "0x" },
            witnesses: inputs.map { _ in Witness(data: ["0x"]) }
        )
    }

    /// Collect inputs from live cells in a FIFO manner.
    /// - Returns: Collected inputs and change amount.
    func collectInputs() -> ([CellInput], Capacity) {
        let amountToCollect = amount + fee
        var amountCollected = Capacity(0)
        var inputs = [CellInput]()

        let unspentCells = collector.getUnspentCells(from: 0, maxCapacity: amountToCollect)
        collecting: for cell in unspentCells.cells {
            let input = CellInput(previousOutput: cell.outPoint, since: 0)
            inputs.append(input)
            amountCollected += cell.capacity

            if amountCollected >= amountToCollect {
                let diff = amountCollected - amountToCollect
                if diff >= Payment.minAmount || diff == 0 {
                    break collecting
                }
            }
        }

        if amountToCollect > amountCollected {
            return ([], 0)
        }
        self.lastBlockNumber = unspentCells.lastBlockNumber
        return (inputs, amountCollected - amountToCollect)
    }

    var cellDep: CellDep {
        return CellDep(outPoint: systemScript.depOutPoint, depType: .depGroup)
    }

    var collector: UnspentCellCollector {
        return unspentCellCollectorType.init(apiClient: apiClient, publicKeyHash: Data(hex: fromPublicKeyHash))
    }
}
