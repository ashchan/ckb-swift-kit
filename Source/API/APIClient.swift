//
//  APIClient.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation
import AsyncHTTPClient

/// JSON RPC API client.
/// Implement CKB [JSON-RPC](https://github.com/nervosnetwork/ckb/tree/develop/rpc#ckb-json-rpc-protocols) interfaces.
public class APIClient {
    private let url: URL
    private let httpClient: HTTPClient

    public static let defaultLocalURL = URL(string: "http://localhost:8114")!

    public init(url: URL = APIClient.defaultLocalURL) {
        self.url = url
        httpClient = HTTPClient(eventLoopGroupProvider: .createNew)
    }

    deinit {
        try? httpClient.syncShutdown()
    }

    public func load<R: Codable>(_ request: APIRequest<R>) throws -> R {
        let result = try loadNullable(request)
        if let result = result {
            return result
        }
        throw APIError.emptyResponse
    }

    public func loadNullable<R: Codable>(_ request: APIRequest<R>) throws -> R? {
        var result: R?
        var err: Error?

        do {
            let httpRequest = try createRequest(request)
            let response = try httpClient.execute(request: httpRequest).wait()
            if response.status == .ok {
                let bytes = response.body.flatMap { $0.getData(at: 0, length: $0.readableBytes) }
                result = try request.decode(bytes!)
            } else {
                err = APIError.genericError("Response status code: \(response.status.code), reason: \(response.status.reasonPhrase)")
            }
        } catch {
            err = APIError.genericError(error.localizedDescription)
        }

        if let err = err {
            throw err
        }

        return result
    }

    private func createRequest<R>(_ request: APIRequest<R>) throws -> HTTPClient.Request {
        var req = try HTTPClient.Request(url: url, method: .POST)
        req.headers.add(name: "Content-Type", value: "application/json")

        let jsonObject: Any = [ "jsonrpc": "2.0", "id": request.id, "method": request.method, "params": request.params ]
        if !JSONSerialization.isValidJSONObject(jsonObject) {
            throw APIError.invalidParameters
        }
        let body = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        req.body = .data(body)

        return req
    }
}

extension APIClient {
    public func genesisBlockHash() throws -> H256 {
        return try getBlockHash(number: 0)
    }

    public func genesisBlock() throws -> Block {
        return try getBlockByNumber(number: 0)
    }
}
