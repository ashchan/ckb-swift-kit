//
//  APIClient+Chain.swift
//  CKB
//
//  Created by James Chen on 2019/06/19.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    func getBlock(hash: H256) throws -> Block {
        return try load(APIRequest<Block>(method: "get_block", params: [hash]))
    }

    func getBlockByNumber(number: BlockNumber) throws -> Block {
        return try load(APIRequest<Block>(method: "get_block_by_number", params: [number]))
    }

    func getTransaction(hash: H256) throws -> TransactionWithStatus {
        return try load(APIRequest<TransactionWithStatus>(method: "get_transaction", params: [hash]))
    }

    func getBlockHash(number: BlockNumber) throws -> H256 {
        return try load(APIRequest<String>(method: "get_block_hash", params: [number]))
    }

    func getTipHeader() throws -> Header {
        return try load(APIRequest<Header>(method: "get_tip_header"))
    }

    func getCellsByLockHash(lockHash: H256, from: BlockNumber, to: BlockNumber) throws -> [CellOutputWithOutPoint] {
        return try load(APIRequest<[CellOutputWithOutPoint]>(method: "get_cells_by_lock_hash", params: [lockHash, from, to]))
    }

    func getLiveCell(outPoint: OutPoint) throws -> CellWithStatus {
        return try load(APIRequest<CellWithStatus>(method: "get_live_cell", params: [outPoint.param]))
    }

    func getTipBlockNumber() throws -> BlockNumber {
        return try load(APIRequest<BlockNumber>(method: "get_tip_block_number"))
    }

    func getCurrentEpoch() throws -> Epoch {
        return try load(APIRequest<Epoch>(method: "get_current_epoch"))
    }

    func getEpochByNumber(number: EpochNumber) throws -> Epoch {
        return try load(APIRequest<Epoch>(method: "get_epoch_by_number", params: [number]))
    }
}
