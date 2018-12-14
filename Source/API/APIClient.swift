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

    public init(url: URL) {
        self.url = url
    }

    public func load<R: Codable>(_ request: APIRequest<R>, id: Int = 1, completionHandler: @escaping (_ response: R?, _ error: APIError?) -> Void) {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonObject: Any = [ "jsonrpc": "2.0", "id": id, "method": request.method, "params": request.params ]
            if !JSONSerialization.isValidJSONObject(jsonObject) {
                throw APIError.invalidParameters
            }
            req.httpBody = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            return completionHandler(nil, .invalidParameters)
        }

        URLSession.shared.dataTask(with: req) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    return completionHandler(nil, .genericError(error.localizedDescription))
                }

                guard let data = data else {
                    return completionHandler(nil, .emptyResponse)
                }

                do {
                    let result = try request.decode(data)
                    completionHandler(result, nil)
                } catch let error {
                    if let apiError = error as? APIError {
                        completionHandler(nil, apiError)
                    } else {
                        completionHandler(nil, .genericError(error.localizedDescription))
                    }
                }
            }
        }.resume()
    }
}
