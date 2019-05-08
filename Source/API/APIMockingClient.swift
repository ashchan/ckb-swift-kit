//
//  APIMockingClient.swift
//  CKB
//
//  Created by James Chen on 2019/04/29.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

class APIMockingClient: APIClient {
    var mockingData: Data?

    public override func load<R: Codable>(_ request: APIRequest<R>) throws -> R {
        var result: R?

        guard let data = mockingData else {
            throw APIError.emptyResponse
        }
        do {
            result = try request.decode(data)
        } catch let err {
            throw err
        }

        if result == nil {
            throw APIError.emptyResponse
        }
        return result!
    }
}
