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
    func testRequestRPC() {
        let expectation = XCTestExpectation(description: "Access JSON RPC")

        let client = APIClient(url: URL(string: "https://web3.gastracker.io")!)
        client.request(method: "eth_blockNumber") { (json, error) in
            XCTAssertNotNil(json)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
