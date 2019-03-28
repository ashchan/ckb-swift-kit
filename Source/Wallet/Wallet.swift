//
//  Wallet.swift
//  CKB
//
//  Created by 翟泉 on 2019/3/27.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

let minCellCapacity: Capacity = 40

enum WalletError: Error {
    case invalidCapacity
    case notEnoughCapacity
}

class Wallet {
    let privateKey: H256
    let api: APIClient

    init(privateKey: String, api: APIClient) {
        self.privateKey = privateKey
        self.api = api
    }

    func sendCapacity(targetAddress: H256, capacity: Capacity) throws -> H256 {
        let tx = try generateTx(targetAddress: targetAddress, capacity: capacity)
        return try api.sendTransaction(transaction: tx)
    }

    func getUnspentCells() throws -> [CellOutputWithOutPoint] {
        return try api.getCellsByTypeHash(typeHash: address, from: 1, to: try api.getTipBlockNumber())
    }

    func getBalance() throws -> Capacity {
        return try getUnspentCells().reduce(0, { $0 + $1.capacity })
    }
}

extension Wallet {
    var publicKey: H256 {
        return Utils.privateToPublic(privateKey)
    }

    var unlockScript: Script {
        return api.verifyScript(for: publicKey)
    }

    var address: H256 {
        return unlockScript.typeHash
    }
}

extension Wallet {
    struct ValidInputs {
        let cellInputs: [CellInput]
        let capacity: Capacity
    }

    func gatherInputs(address: H256, capacity: Capacity, minCapacity: Capacity = minCellCapacity) throws -> ValidInputs {
        guard capacity < minCapacity else { throw WalletError.invalidCapacity }
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
        guard inputCapacities > capacity else { throw WalletError.notEnoughCapacity }
        return ValidInputs(cellInputs: inputs, capacity: inputCapacities)
    }
}

extension Wallet {
    func generateTx(targetAddress: H256, capacity: Capacity) throws -> Transaction {
        let validInputs = try gatherInputs(address: address, capacity: capacity, minCapacity: 0)
        var outputs: [CellOutput] = [
            CellOutput(capacity: capacity, data: "", lock: targetAddress, type: nil)
        ]
        if validInputs.capacity > capacity {
            outputs.append(CellOutput(capacity: validInputs.capacity - capacity, data: "", lock: address, type: nil))
        }
        return Transaction(version: 0, deps: [api.mrubyOutPoint], inputs: validInputs.cellInputs, outputs: outputs, hash: privateKey)
    }
}
