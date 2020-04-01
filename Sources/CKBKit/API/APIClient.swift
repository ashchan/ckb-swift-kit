//
//  APIClient.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation
import Combine
import CKBFoundation

/// JSON RPC API client.
/// Implement CKB [JSON-RPC](https://github.com/nervosnetwork/ckb/tree/develop/rpc#ckb-json-rpc-protocols) interfaces.
public class APIClient {
    private let url: URL

    public static let defaultLocalURL = URL(string: "http://localhost:8114")!

    public init(url: URL = APIClient.defaultLocalURL) {
        self.url = url
    }

    public func load<R: Codable>(_ request: APIRequest) -> Future<R, APIError> {
        return Future<R, APIError> { [unowned self] promise in
            let req: URLRequest
            do {
                req = try self.createRequest(request)
            } catch {
                return promise(.failure(error as! APIError))
            }

            URLSession.shared.dataTask(with: req) { (data, _, err) in
                do {
                    guard let data = data else {
                        return promise(.failure(APIError.emptyResponse))
                    }
                    let result = try JSONDecoder().decode(R.self, from: data)
                    return promise(.success(result))
                } catch {
                    return promise(.failure(APIError.genericError(error.localizedDescription)))
                }
            }.resume()
        }
    }

    private func createRequest(_ request: APIRequest) throws -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonObject: Any = [ "jsonrpc": "2.0", "id": request.id, "method": request.method, "params": request.params ]
        if !JSONSerialization.isValidJSONObject(jsonObject) {
            throw APIError.invalidParameters
        }
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            throw APIError.genericError(error.localizedDescription)
        }

        return req
    }
}

extension APIClient {
    public func genesisBlockHash() -> Future<H256, APIError> {
        getBlockHash(number: 0)
    }

    public func genesisBlock() -> Future<Block, APIError> {
        getBlockByNumber(number: 0)
    }
}
