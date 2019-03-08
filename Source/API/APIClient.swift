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

            do {
                guard data != nil else {
                    throw APIError.emptyResponse
                }

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

    public func genesisBlock() throws -> Block {
        return try getBlock(hash: try genesisBlockHash())
    }
}

// MARK: - Chain RPC Methods

extension APIClient {
    public func getBlock(hash: H256) throws -> Block {
        return try load(APIRequest<Block>(method: "get_block", params: [hash]))
    }

    public func getTransaction(hash: H256) throws -> Transaction {
        return try load(APIRequest<Transaction>(method: "get_transaction", params: [hash]))
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

// MARK: - Info for mruby script and verify cell

extension APIClient {
    func setMrubyConfig(outPoint: OutPoint, cellHash: String) {
        mrubyOutPoint = outPoint
        mrubyCellHash = cellHash
    }

    func verifyScript(for publicKey: String) -> Script {
        let signedArgs = [
            VerifyScript.script.content,
            Utils.prefixHex(publicKey.data(using: .utf8)!.toHexString())
            // Although public key itself is a hex string, when loaded as binary the format is ignored.
        ]
        return Script(
            version: 0,
            binary: nil,
            reference: mrubyCellHash,
            signedArgs: signedArgs,
            args: []
        )
    }

    // https://github.com/nervosnetwork/ckb/blob/master/nodes_template/spec/cells/always_success
    var alwaysSuccessCellBytes: [UInt8] {
        // swiftlint:disable:next line_length
        let hex = "7F454C46 02010100 00000000 00000000 0200F300 01000000 78000100 00000000 40000000 00000000 98000000 00000000 05000000 40003800 01004000 03000200 01000000 05000000 00000000 00000000 00000100 00000000 00000100 00000000 82000000 00000000 82000000 00000000 00100000 00000000 01459308 D0057300 0000002E 73687374 72746162 002E7465 78740000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000 0B000000 01000000 06000000 00000000 78000100 00000000 78000000 00000000 0A000000 00000000 00000000 00000000 02000000 00000000 00000000 00000000 01000000 03000000 00000000 00000000 00000000 00000000 82000000 00000000 11000000 00000000 00000000 00000000 01000000 00000000 00000000 00000000"
        return [UInt8](hex: hex.replacingOccurrences(of: " ", with: ""))
    }

    func alwaysSuccessCellHash() throws -> String {
        let systemCells = try genesisBlock().commitTransactions.first!.outputs
        guard let cell = systemCells.first else {
            throw APIError.genericError("Cannot find always success cell")
        }
        let hash = Blake2b().hash(data: Data(hex: cell.data))!
        return Utils.prefixHex(hash.toHexString())
    }

    func alwaysSuccessScriptOutPoint() throws -> OutPoint {
        let hash = try genesisBlock().commitTransactions.first!.hash
        return OutPoint(hash: hash, index: 0)
    }
}
