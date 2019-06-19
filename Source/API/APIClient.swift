//
//  APIClient.swift
//  CKB
//
//  Created by James Chen on 2018/12/13.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

/// JSON RPC API client.
/// Implement CKB [JSON-RPC](https://github.com/nervosnetwork/ckb/tree/develop/rpc#json-rpc) interfaces.
public class APIClient {
    private var url: URL
    public static let defaultLocalURL = URL(string: "http://localhost:8114")!

    public init(url: URL = APIClient.defaultLocalURL) {
        self.url = url
    }

    public func load<R: Codable>(_ request: APIRequest<R>) throws -> R {
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

    private func createRequest<R>(_ request: APIRequest<R>) throws -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonObject: Any = [ "jsonrpc": "2.0", "id": request.id, "method": request.method, "params": request.params ]
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
