//
//  APIClient+Chain.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Combine
import CKBFoundation

public extension APIClient {
    func getBlock(hash: H256) -> Future<Block, APIError> {
         load(APIRequest(method: "get_block", params: [hash]))
    }

    func getBlockByNumber(number: BlockNumber) -> Future<Block, APIError> {
         load(APIRequest(method: "get_block_by_number", params: [number.hexString]))
    }

    func getTransaction(hash: H256) -> Future<TransactionWithStatus, APIError> {
         load(APIRequest(method: "get_transaction", params: [hash]))
    }

    func getBlockHash(number: BlockNumber) -> Future<H256, APIError> {
         load(APIRequest(method: "get_block_hash", params: [number.hexString]))
    }

    func getTipHeader() -> Future<Header, APIError> {
         load(APIRequest(method: "get_tip_header"))
    }

    func getHeader(blockHash: H256) -> Future<Header, APIError> {
         load(APIRequest(method: "get_header", params: [blockHash]))
    }

    func getHeaderByNumber(number: BlockNumber) -> Future<Header, APIError> {
         load(APIRequest(method: "get_header_by_number", params: [number.hexString]))
    }

    func getCellsByLockHash(lockHash: H256, from: BlockNumber, to: BlockNumber) -> Future<[CellOutputWithOutPoint], APIError> {
         load(APIRequest(
            method: "get_cells_by_lock_hash",
            params: [lockHash, from.hexString, to.hexString]
        ))
    }

    func getLiveCell(outPoint: OutPoint, withData: Bool = true) -> Future<CellWithStatus, APIError> {
         load(APIRequest(method: "get_live_cell", params: [outPoint.param, withData]))
    }

    func getTipBlockNumber() -> Future<String, APIError> {
         load(APIRequest(method: "get_tip_block_number"))
    }

    func getCurrentEpoch() -> Future<Epoch, APIError> {
         load(APIRequest(method: "get_current_epoch"))
    }

    func getEpochByNumber(number: EpochNumber) -> Future<Epoch, APIError> {
         load(APIRequest(method: "get_epoch_by_number", params: [number.hexString]))
    }

    func getCellbaseOutputCapacityDetails(blockHash: H256) -> Future<BlockReward, APIError> {
         load(APIRequest(method: "get_cellbase_output_capacity_details", params: [blockHash]))
    }
}
