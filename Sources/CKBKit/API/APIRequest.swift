//
//  APIRequest.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

/// JSON RPC request object.
public struct APIRequest {
    let id: String
    let method: String
    let params: [Any?]

    init(id: String = UUID().uuidString, method: String, params: [Any?] = []) {
        self.id = id
        self.method = method
        self.params = params
    }
}
