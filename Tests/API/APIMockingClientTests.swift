//
//  APIMockingClientTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
import CKBFoundation
@testable import CKBKit

class APIMockingClientTests: XCTestCase {
    func testNullData() {
        let client = APIMockingClient()
        XCTAssertThrowsError(try client.load(APIRequest<BlockNumber>(method: "get_tip_block_number"))) { error in
            XCTAssertEqual(
                error.localizedDescription,
                APIError.emptyResponse.localizedDescription
            )
        }
    }

    func testNullResult() {
        let client = APIMockingClient()
        client.mockingData = "{\"jsonrpc\":\"2.0\", \"id\":\"1\", \"result\":null}".data(using: .utf8)
        XCTAssertThrowsError(try client.load(APIRequest<BlockNumber>(method: "get_tip_block_number"))) { error in
            XCTAssertEqual(
                error.localizedDescription,
                APIError.emptyResponse.localizedDescription
            )
        }
    }
}
