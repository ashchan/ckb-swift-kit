//
//  LiveCellCollector.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// LiveCellCollector collects live cells (unspent cells) provided a public key.
final class LiveCellCollector {
    private let apiClient: APIClient
    let publicKey: Data

    lazy var lock: Script = {
        let systemScript = try! SystemScript.loadSystemScript(apiClient: apiClient)
        return systemScript.lock(for: publicKey)
    }()

    var lockHash: String {
        return lock.computeHash()
    }

    init(apiClient: APIClient, publicKey: Data) {
        self.apiClient = apiClient
        self.publicKey = publicKey
    }

    // Collect all unspent cells from genesis block to current tip.
    // All types of live cells are collected.
    // Performance concern: this has to iterate over all blocks. It would be very slow.
    func getUnspentCells() -> [CellOutputWithOutPoint] {
        var from = BlockNumber(0)
        var to = BlockNumber(0)
        let step = BlockNumber(100) // Max allowed is 100
        guard let tip = try? apiClient.getTipBlockNumber() else {
            return []
        }

        var results = [CellOutputWithOutPoint]()
        while from <= tip {
            to = [from + step, tip].min()!
            if let cells = try? apiClient.getCellsByLockHash(lockHash: lockHash, from: from, to: to) {
                results.append(contentsOf: cells)
            }
            from = to + 1
        }

        return results
    }
}
