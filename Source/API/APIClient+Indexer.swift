//
//  APIClient+Indexer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    func indexLockHash(lockHash: H256, indexFrom: BlockNumber? = nil) throws -> LockHashIndexState {
        return try load(APIRequest<LockHashIndexState>(
            method: "index_lock_hash",
            params: [lockHash, indexFrom?.hexString].compactMap { $0 }
        ))
    }

    func deindexLockHash(lockHash: H256) throws -> Bool? {
        return try loadNullable(APIRequest<Bool>(method: "deindex_lock_hash", params: [lockHash]))
    }

    func getLockHashIndexStates() throws -> [LockHashIndexState] {
        return try load(APIRequest<[LockHashIndexState]>(method: "get_lock_hash_index_states", params: []))
    }

    func getLiveCellsByLockHash(lockHash: H256, page: UInt32, pageSize: UInt32, reverseOrder: Bool = false) throws -> [LiveCell] {
        return try load(APIRequest<[LiveCell]>(
            method: "get_live_cells_by_lock_hash",
            params: [lockHash, page.hexString, pageSize.hexString, reverseOrder]
        ))
    }

    func getTransactionsByLockHash(lockHash: H256, page: UInt32, pageSize: UInt32, reverseOrder: Bool = false) throws -> [CellTransaction] {
        return try load(APIRequest<[CellTransaction]>(
            method: "get_transactions_by_lock_hash",
            params: [lockHash, page.hexString, pageSize.hexString, reverseOrder]
        ))
    }
}
