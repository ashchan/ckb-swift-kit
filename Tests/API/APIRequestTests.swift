//
//  APIRequestTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class APIRequestTests: XCTestCase {
    func testInvalidData() {
        let data = "{}".data(using: .utf8)!
        XCTAssertThrowsError(try APIRequest<BlockNumber>(method: "get_tip_block_number").decode(data))
    }

    func testHasError() {
        let data = "{\"jsonrpc\":\"2.0\", \"id\":1, \"result\":\"123\", \"error\":{\"code\":1, \"message\":\"Some error\"}}".data(using: .utf8)!
        XCTAssertThrowsError(try APIRequest<HexString>(method: "get_tip_block_number").decode(data)) { error in
            XCTAssertEqual(
                error.localizedDescription,
                APIError.genericError("Some error").localizedDescription
            )
        }
    }

    func testUnmatchedId() {
        let data = "{\"jsonrpc\":\"2.0\", \"id\":1, \"result\":\"123\"}".data(using: .utf8)!
        XCTAssertThrowsError(try APIRequest<HexString>(id: 2, method: "get_tip_block_number").decode(data)) { error in
            XCTAssertEqual(
                error.localizedDescription,
                APIError.unmatchedId.localizedDescription
            )
        }
    }
}
