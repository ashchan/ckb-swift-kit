//
//  APIClientTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/13.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class APIClientTests: XCTestCase {
    func testRequestRPC() throws {
        let request = APIRequest<String>(method: "eth_blockNumber", params: [])
        let client = APIClient(url: URL(string: "https://web3.gastracker.io")!)
        let result = try client.load(request)
        XCTAssertNotNil(result)
    }
}
