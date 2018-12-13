//
//  APIClient.swift
//  CKB
//
//  Created by James Chen on 2018/12/13.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public class APIClient {
    private var url: URL

    public init(url: URL) {
        self.url = url
    }

    public typealias CompletionHandler = (_ response: [String: Any]?, _ error: Error?) -> Void

    public func request(method: String, params: [Any] = [], id: Int = 1, completionHandler: @escaping CompletionHandler) {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            req.httpBody = try JSONSerialization.data(
                withJSONObject: [ "jsonrpc": "2.0", "id": id, "method": method, "params": params ],
                options: .prettyPrinted
            )
        } catch {
            return completionHandler(nil, Error.invalidParam)
        }

        URLSession.shared.dataTask(with: req) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    return completionHandler(nil, Error.other(error.localizedDescription))
                }

                guard let data = data else {
                    return completionHandler(nil, Error.emptyData)
                }

                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                        return completionHandler(nil, Error.invalidJSON)
                    }
                    completionHandler(json, nil)
                } catch let error {
                    completionHandler(nil, Error.other(error.localizedDescription))
                }
            }
        }.resume()
    }
}

extension APIClient {
    public enum Error: Swift.Error {
        case invalidParam
        case emptyData
        case invalidJSON
        case other(String)
    }
}
