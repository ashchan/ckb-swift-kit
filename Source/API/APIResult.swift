//
//  APIResult.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct APIError: Codable, LocalizedError {
    let code: Int
    let message: String

    var localizedDescription: String {
        return message
    }
}

extension APIError {
    static let genericErrorCode = -1
    static let invalidParameters = APIError(code: genericErrorCode, message: "Invalid parameters")
    static let emptyResponse = APIError(code: genericErrorCode, message: "Empty response")
    static let nullResult = APIError(code: genericErrorCode, message: "Null result")
    static let unmatchedId = APIError(code: genericErrorCode, message: "Unmatched id")
    static func genericError(_ message: String) -> APIError {
        return APIError(code: genericErrorCode, message: message)
    }
}

/// JSON API Response
struct APIResult<R: Codable>: Codable {
    let jsonrpc: String
    let id: Int
    let error: APIError?
    let result: R?
}
