//
//  APIMockingClient.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

class APIMockingClient: APIClient {
    var mockingData: Data?

    public override func loadNullable<R: Codable>(_ request: APIRequest<R>) throws -> R? {
        var result: R?

        guard let data = mockingData else {
            throw APIError.emptyResponse
        }
        do {
            result = try request.decode(data)
        } catch let err {
            throw err
        }

        return result
    }
}
