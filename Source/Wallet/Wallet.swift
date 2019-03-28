//
//  Wallet.swift
//  CKB
//
//  Created by 翟泉 on 2019/3/27.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

let minCellCapacity: Capacity = 40

public class Wallet {
    public let privateKey: H256
    public let api: APIClient

    public var publicKey: H256 {
        return Utils.privateToPublic(privateKey)
    }

    public var address: H256 {
        return unlockScript.typeHash
    }

    var unlockScript: Script {
        return api.verifyScript(for: publicKey)
    }

    var deps: [OutPoint] {
        return [api.mrubyOutPoint]
    }

    public init(privateKey: H256, api: APIClient) {
        self.privateKey = privateKey
        self.api = api
    }

    public func getBalance() throws -> Capacity {
        return try getUnspentCells().reduce(0, { $0 + $1.capacity })
    }

    public func sendCapacity(targetAddress: H256, capacity: Capacity) throws -> H256 {
        let tx = try generateTransaction(targetAddress: targetAddress, capacity: capacity)
        return try api.sendTransaction(transaction: tx)
    }
}

extension Wallet {
    typealias Element = CellOutputWithOutPoint

    struct UnspentCellsIterator: IteratorProtocol {
        let api: APIClient
        let address: H256
        var fromBlockNumber: BlockNumber
        let tipBlockNumber: BlockNumber
        var cells = [CellOutputWithOutPoint]()

        init(api: APIClient, address: H256) throws {
            self.api = api
            self.address = address
            fromBlockNumber = 1
            tipBlockNumber = try api.getTipBlockNumber()
        }

        mutating func next() -> CellOutputWithOutPoint? {
            guard cells.count == 0 else {
                return cells.removeFirst()
            }
            while fromBlockNumber <= tipBlockNumber {
                let toBlockNumber = min(fromBlockNumber + 800, tipBlockNumber)
                defer {
                    fromBlockNumber = toBlockNumber + 1
                }
                if var cells = try? api.getCellsByTypeHash(typeHash: address, from: fromBlockNumber, to: toBlockNumber), cells.count > 0 {
                    defer {
                        self.cells = cells
                    }
                    return cells.removeFirst()
                }
            }
            return nil
        }
    }

    func getUnspentCells() throws -> IteratorSequence<UnspentCellsIterator> {
        return IteratorSequence(try UnspentCellsIterator(api: api, address: address))
    }
}

extension Wallet {
    struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Capacity
    }

    func gatherInputs(capacity: Capacity, minCapacity: Capacity = minCellCapacity) throws -> ValidInputs {
        guard capacity > minCapacity else {
            throw WalletError.tooLowCapacity(min: minCapacity)
        }
        var inputCapacities: Capacity = 0
        var inputs = [CellInput]()
        for cell in try getUnspentCells() {
            let input = CellInput(previousOutput: cell.outPoint, unlock: unlockScript)
            inputs.append(input)
            inputCapacities += cell.capacity
            if inputCapacities - capacity >= minCapacity {
                break
            }
        }
        guard inputCapacities > capacity else {
            throw WalletError.notEnoughCapacity(required: capacity, available: inputCapacities)
        }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }

    func generateTransaction(targetAddress: H256, capacity: Capacity) throws -> Transaction {
        let validInputs = try gatherInputs(capacity: capacity, minCapacity: minCellCapacity)
        var outputs: [CellOutput] = [
            CellOutput(capacity: capacity, data: "0x", lock: targetAddress, type: nil)
        ]
        if validInputs.capacity > capacity {
            outputs.append(CellOutput(capacity: validInputs.capacity - capacity, data: "0x", lock: address, type: nil))
        }
        return Transaction(deps: deps, inputs: validInputs.cellInputs, outputs: outputs, hash: privateKey)
    }
}
