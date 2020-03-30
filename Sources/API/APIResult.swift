//
//  APIResult.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

/// JSON API Response
struct APIResult<R: Codable>: Codable {
    let jsonrpc: String
    let id: String
    let error: APIError?
    let result: R?
}
