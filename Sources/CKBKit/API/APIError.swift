//
//  APIError.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct APIError: Codable, LocalizedError {
    let code: Int
    let message: String

    var errorDescription: String {
        message
    }
}

extension APIError {
    static let genericErrorCode = -1
    static let invalidParameters = APIError(code: genericErrorCode, message: "Invalid parameters")
    static let emptyResponse = APIError(code: genericErrorCode, message: "Empty response")
    static let nullResult = APIError(code: genericErrorCode, message: "Null result")
    static let unmatchedId = APIError(code: genericErrorCode, message: "Unmatched id")
    static func genericError(_ message: String) -> APIError {
        APIError(code: genericErrorCode, message: message)
    }
}
