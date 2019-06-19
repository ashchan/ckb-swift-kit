//
//  APIClient+Indexer.swift
//  CKB
//
//  Created by James Chen on 2019/06/19.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    // FIXME: indexFrom `null` has different meaning!
    func indexLockHash(lockHash: H256, indexFrom: BlockNumber = "0") throws -> LockHashIndexState {
        return try load(APIRequest<LockHashIndexState>(method: "index_lock_hash", params: [lockHash, indexFrom]))
    }

    // Although this declares to return `H256`, the RPC actually always returns nil.
    func deindexLockHash(lockHash: H256) throws -> H256? {
        return try loadNullable(APIRequest<H256>(method: "deindex_lock_hash", params: [lockHash]))
    }

    func getLockHashIndexStates() throws -> [LockHashIndexState] {
        return try load(APIRequest<[LockHashIndexState]>(method: "get_lock_hash_index_states", params: []))
    }

    func getLiveCellsByLockHash(lockHash: H256, page: Number, pageSize: Number, reverseOrder: Bool = false) throws -> [LiveCell] {
        return try load(APIRequest<[LiveCell]>(
            method: "get_live_cells_by_lock_hash",
            params: [lockHash, page, pageSize, reverseOrder]
        ))
    }

    func getTransactionsByLockHash(lockHash: H256, page: Number, pageSize: Number, reverseOrder: Bool = false) throws -> [CellTransaction] {
        return try load(APIRequest<[CellTransaction]>(
            method: "get_transactions_by_lock_hash",
            params: [lockHash, page, pageSize, reverseOrder]
        ))
    }
}
