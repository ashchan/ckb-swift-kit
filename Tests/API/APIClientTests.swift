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

        let request = APIRequest<String>(method: "eth_blockNumber", params: [])
        let client = APIClient(url: URL(string: "https://web3.gastracker.io")!)
        client.load(request) { (result, error) in
            XCTAssertNotNil(result)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }
}
