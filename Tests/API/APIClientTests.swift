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
        let result = try client.getCellsByTypeHash(typeHash: "0xb3c01133a371480a184372500197033850d53b482c0005795604bedba5d90978", from: 1, to: 100)
        XCTAssertNotNil(result)
    }

    func testGetCurrentCell() throws {
        let client = APIClient()
        let cells = try client.getCellsByTypeHash(typeHash: "0xb3c01133a371480a184372500197033850d53b482c0005795604bedba5d90978", from: 1, to: 100)
        let result = try client.getCurrentCell(outPoint: cells.first!.outPoint)
        XCTAssertNotNil(result)
    }

    func testSendTransaction() throws {
    }

    func testGetBlockTemplate() throws {
        let client = APIClient()
        let result = try client.getBlockTemplate(typeHash: "0xb3c01133a371480a184372500197033850d53b482c0005795604bedba5d90978", maxTransactions: 1000, maxProposals: 1000)
        XCTAssertNotNil(result)
    }

    func testSubmitBlock() throws {
    }
}
