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
    func testGenesisBlock() throws {
        let result = try APIClient().genesisBlock()
        XCTAssertNotNil(result)
    }

    func testGetBlock() throws {
        let client = APIClient()
        let hash = try client.genesisBlock()
        let result = try client.getBlock(hash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(hash, result.hash)
    }

    func testGetTransaction() throws {
        XCTFail("TODO: Add get transaction test")
    }

    func testGetBlockHash() throws {
        let result = try APIClient().getBlockHash(number: 1)
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
        let client = APIClient()
        let result = try client.getTipHeader()
        XCTAssertNotNil(result)
        XCTAssertTrue(result.raw.number > 0)
    }

    func testGetCellsByTypeHash() throws {
        let client = APIClient()
        let result = try client.getCellsByTypeHash(typeHash: "0x565cd9ac9a251109ff642090b91af29bfaa451b2d0e3093a29bba74743408a4a", from: 1, to: 100)
        XCTAssertNotNil(result)
    }

    func testGetCurrentCell() throws {
        let client = APIClient()
        let cells = try client.getCellsByTypeHash(typeHash: "0x565cd9ac9a251109ff642090b91af29bfaa451b2d0e3093a29bba74743408a4a", from: 1, to: 100)
        let result = try client.getCurrentCell(outPoint: cells.first!.outPoint)
        XCTAssertNotNil(result)
    }

    func testSendTransaction() throws {
        XCTFail("TODO: Add send transaction test")
    }

    func testGetBlockTemplate() throws {
        let client = APIClient()
        let result = try client.getBlockTemplate(typeHash: "0x565cd9ac9a251109ff642090b91af29bfaa451b2d0e3093a29bba74743408a4a", maxTransactions: 1000, maxProposals: 1000)
        XCTAssertNotNil(result)
    }

    // Don't know if we have to test this.
    func xtestSubmitBlock() throws {}
}
