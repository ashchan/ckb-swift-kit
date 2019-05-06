//
//  APIClient.swift
//  CKB
//
//  Created by James Chen on 2018/12/13.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

/// JSON RPC API client.
public class APIClient {
    private var url: URL
    public static let defaultLocalURL = URL(string: "http://localhost:8114")!

    public init(url: URL = APIClient.defaultLocalURL) {
        self.url = url
    }

    public func load<R: Codable>(_ request: APIRequest<R>, id: Int = 1) throws -> R {
        var result: R?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: try createRequest(request)) { (data, _, err) in
            error = err

            do {
                guard let data = data else {
                    throw APIError.emptyResponse
                }
                result = try request.decode(data)
            } catch let err {
                error = err
            }

            semaphore.signal()
        }.resume()
        semaphore.wait()

        if let error = error {
            throw error
        }

        if result == nil {
            throw APIError.emptyResponse
        }
        return result!
    }

    private func createRequest<R>(_ request: APIRequest<R>, id: Int = 1) throws -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonObject: Any = [ "jsonrpc": "2.0", "id": id, "method": request.method, "params": request.params ]
        if !JSONSerialization.isValidJSONObject(jsonObject) {
            throw APIError.invalidParameters
        }
        req.httpBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)

        return req
    }
}

extension APIClient {
    public func genesisBlockHash() throws -> H256 {
        return try getBlockHash(number: "0")
    }

    public func genesisBlock() throws -> Block {
        return try getBlockByNumber(number: "0")
    }
}

// MARK: - Chain RPC Methods

extension APIClient {
    public func getBlock(hash: H256) throws -> Block {
        return try load(APIRequest<Block>(method: "get_block", params: [hash]))
    }

    public func getBlockByNumber(number: BlockNumber) throws -> Block {
        return try load(APIRequest<Block>(method: "get_block_by_number", params: [number]))
    }

    public func getTransaction(hash: H256) throws -> TransactionWithStatus {
        return try load(APIRequest<TransactionWithStatus>(method: "get_transaction", params: [hash]))
    }

    public func getBlockHash(number: BlockNumber) throws -> H256 {
        return try load(APIRequest<String>(method: "get_block_hash", params: [number]))
    }

    public func getTipHeader() throws -> Header {
        return try load(APIRequest<Header>(method: "get_tip_header"))
    }

    public func getCellsByLockHash(lockHash: H256, from: BlockNumber, to: BlockNumber) throws -> [CellOutputWithOutPoint] {
        return try load(APIRequest<[CellOutputWithOutPoint]>(method: "get_cells_by_lock_hash", params: [lockHash, from, to]))
    }

    public func getLiveCell(outPoint: OutPoint) throws -> CellWithStatus {
        return try load(APIRequest<CellWithStatus>(method: "get_live_cell", params: [outPoint.param]))
    }

    public func getTipBlockNumber() throws -> BlockNumber {
        return try load(APIRequest<BlockNumber>(method: "get_tip_block_number"))
    }
}

// MARK: - Pool RPC Methods

extension APIClient {
    public func sendTransaction(transaction: Transaction) throws -> H256 {
        return try load(APIRequest<H256>(method: "send_transaction", params: [transaction.param]))
    }
}

// MARK: - Network RPC Methods

extension APIClient {
    public func localNodeInfo() throws -> LocalNode {
        return try load(APIRequest<LocalNode>(method: "local_node_info", params: []))
    }
}

// MARK: - Trace RPC Methods

extension APIClient {
    public func traceTransaction(transaction: Transaction) throws -> H256 {
        return try load(APIRequest<H256>(method: "trace_transaction", params: [transaction.param]))
    }

    public func getTransactionTrace(hash: H256) throws -> [TxTrace]? {
        return try load(APIRequest<[TxTrace]?>(method: "get_transaction_trace", params: [hash]))
    }
}
