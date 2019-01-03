//
//  APIClient.swift
//  CKB
//
//  Created by James Chen on 2018/12/13.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation
import CryptoSwift

/// JSON RPC API client.
public class APIClient {
    private var url: URL
    var mrubyOutPoint: OutPoint!
    var mrubyCellHash: String!

    public init(url: URL = URL(string: "http://localhost:8114")!) {
        self.url = url
    }

    public func load<R: Codable>(_ request: APIRequest<R>, id: Int = 1) throws -> R {
        var result: R?
        var error: Error?

        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: try createRequest(request)) { (data, _, err) in
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
        return try getBlockHash(number: 0)
    }

    public func genesisBlock() throws -> BlockWithHash {
        return try getBlock(hash: try genesisBlockHash())
    }
}

// MARK: - Chain RPC Methods

extension APIClient {
    public func getBlock(hash: H256) throws -> BlockWithHash {
        return try load(APIRequest<BlockWithHash>(method: "get_block", params: [hash]))
    }

    public func getTransaction(hash: H256) throws -> TransactionWithHash {
        return try load(APIRequest<TransactionWithHash>(method: "get_transaction", params: [hash]))
    }

    public func getBlockHash(number: BlockNumber) throws -> H256 {
        return try load(APIRequest<String>(method: "get_block_hash", params: [number]))
    }

    public func getTipHeader() throws -> Header {
        return try load(APIRequest<Header>(method: "get_tip_header"))
    }

    public func getCellsByTypeHash(typeHash: H256, from: BlockNumber, to: BlockNumber) throws -> [CellOutputWithOutPoint] {
        return try load(APIRequest<[CellOutputWithOutPoint]>(method: "get_cells_by_type_hash", params: [typeHash, from, to]))
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

// MARK: - Info for mruby script and verify cell

extension APIClient {
    func setMrubyConfig(outPoint: OutPoint, cellHash: String) {
        mrubyOutPoint = outPoint
        mrubyCellHash = cellHash
    }

    func verifyScript(for publicKey: String) -> Script {
        let signedArgs = [
            VerifyScript.script.content,
            publicKey.data(using: .utf8)!.bytes
        ]
        return Script(
            version: 0,
            binary: nil,
            reference: mrubyCellHash,
            signedArgs: signedArgs,
            args: []
        )
    }

    func alwaysSuccessCellHash() throws -> String {
        let systemCells = try genesisBlock().transactions.first!.transaction.outputs
        guard let cell = systemCells.first else {
            throw APIError.genericError("Cannot find always success cell")
        }
        let hash = Data(bytes: cell.data).sha3(.sha256)
        return Utils.prefixHex(hash.toHexString())
    }

    func alwaysSuccessScriptOutPoint() throws -> OutPoint {
        let hash = try genesisBlock().transactions.first!.hash
        return OutPoint(hash: hash, index: 0)
    }
}
