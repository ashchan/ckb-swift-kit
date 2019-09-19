//
//  LiveCellCollector.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public protocol UnspentCellCollector {
    init(apiClient: APIClient, publicKeyHash: Data)
    func getUnspentCells(_ maxCapacity: Capacity) -> [CellOutputWithOutPoint]
}

/// LiveCellCollector collects live cells (unspent cells) provided a public key.
final class LiveCellCollector: UnspentCellCollector {
    private let apiClient: APIClient
    let publicKeyHash: Data

    lazy var lock: Script = {
        let systemScript = try! SystemScript.loadSystemScript(apiClient: apiClient)
        return systemScript.lock(for: publicKeyHash.toHexString())
    }()

    var lockHash: String {
        return lock.computeHash()
    }

    init(apiClient: APIClient, publicKeyHash: Data) {
        self.apiClient = apiClient
        self.publicKeyHash = publicKeyHash
    }

    convenience init(apiClient: APIClient, publicKey: Data) {
        self.init(apiClient: apiClient, publicKeyHash: AddressGenerator.hash(for: publicKey))
    }

    // Collect all unspent cells from genesis block to current tip.
    // All types of live cells are collected.
    // Performance concern: this has to iterate over all blocks. It could be very slow.
    func getUnspentCells(_ maxCapacity: Capacity = .max) -> [CellOutputWithOutPoint] {
        var from = BlockNumber(0)
        var to = BlockNumber(0)
        let step = BlockNumber(100) // Max allowed is 100
        guard let tip = try? apiClient.getTipBlockNumber() else {
            return []
        }

        var capacity = Capacity(0)
        var results = [CellOutputWithOutPoint]()
        while from <= tip && capacity <= maxCapacity {
            to = [from + step, tip].min()!
            if let cells = try? apiClient.getCellsByLockHash(lockHash: lockHash, from: from, to: to) {
                results.append(contentsOf: cells)
                capacity += cells.map { $0.capacity }.reduce(0, +)
            }
            from = to + 1
        }

        return results
    }
}
