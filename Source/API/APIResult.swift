//
//  APIResult.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

/// JSON API Response
struct APIResult<R: Codable>: Codable {
    let jsonrpc: String
    let id: Int
    let error: APIError?
    let result: R?
}
