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

    func testGenesisBlock() throws {
        let client = APIClient()
        let result = try client.genesisBlock()
        XCTAssertNotNil(result)
    }

    func testGetBlock() throws {
    }

    func testGetTransaction() throws {
    }

    func testGetBlockHash() throws {
        let client = APIClient()
        let result = try client.getBlockHash(number: 1)
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
    }

    func testGetCellsByTypeHash() throws {
    }

    func testGetCurrentCell() throws {
    }

    func testSendTransaction() throws {
    }

    func testGetBlockTemplate() throws {
    }

    func testSubmitBlock() throws {
    }
}
