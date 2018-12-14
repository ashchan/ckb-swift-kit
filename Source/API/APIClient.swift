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

    public init(url: URL = URL(string: "http://localhost:8114")!) {
        self.url = url
    }

    public func load<R: Codable>(_ request: APIRequest<R>, id: Int = 1) throws -> R {
        var result: R?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: try createRequest(request)) { (data, response, err) in
            error = err

            if data == nil {
                error = APIError.emptyResponse
            }

            do {
                result = try request.decode(data!)
            } catch let err {
                error = err
            }

            semaphore.signal()
        }.resume()
        semaphore.wait()

        if let error = error {
            throw error
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

    private enum NotImpl: Error {
        case todo
    }
}

extension APIClient {
    public func genesisBlock() throws -> H256 {
        return try getBlockHash(number: 0)
    }
}

// MARK: - Chain RPC Methods

extension APIClient {
    public func getBlock(hash: H256) throws -> BlockWithHash {
        throw NotImpl.todo
    }

    public func getTransaction(hash: H256) throws -> TransactionWithHash {
        throw NotImpl.todo
    }

    public func getBlockHash(number: BlockNumber) throws -> H256 {
        return try load(APIRequest<String>(method: "get_block_hash", params: [number]))
    }

    public func getTipHeader() throws -> Header {
        throw NotImpl.todo
    }

    public func getCellsByTypeHash(typeHash: H256, from: UInt64, to: UInt64) throws -> [CellOutputWithOutPoint] {
        throw NotImpl.todo
    }

    public func getCurrentCell(outPoint: OutPoint) throws -> CellWithStatus {
        throw NotImpl.todo
    }
}

// MARK: - Pool RPC Methods

extension APIClient {
    public func sendTransaction(transaction: Transaction) throws -> H256 {
        throw NotImpl.todo
    }
}

// MARK: - Miner RPC Methods

extension APIClient {
    public func getBlockTemplate(typeHash: String, maxTransactions: UInt, maxProposals: UInt) throws -> BlockTemplate {
        throw NotImpl.todo
    }

    public func submitBlock(block: Block) throws -> H256 {
        throw NotImpl.todo
    }
}
