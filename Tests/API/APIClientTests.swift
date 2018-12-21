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
    func testGenesisBlockHash() throws {
        let result = try APIClient().genesisBlockHash()
        XCTAssertNotNil(result)
    }

    func testGenesisBlock() throws {
        let result = try APIClient().genesisBlock()
        XCTAssertNotNil(result)
    }

    func testGetBlock() throws {
        let client = APIClient()
        let hash = try client.genesisBlockHash()
        let result = try client.getBlock(hash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(hash, result.hash)
    }

    func testGetBlockPerformance() throws {
        let client = APIClient()
        measure {
            _ = try! client.genesisBlock()
        }
    }

    func testGetTransaction() throws {
        let client = APIClient()
        let genesisBlock = try client.genesisBlock()
        if let tx = genesisBlock.transactions.first {
            let result = try client.getTransaction(hash: tx.hash)
            XCTAssertNotNil(result)
            XCTAssertEqual(tx.hash, result.hash)
        }
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
        let result = try client.getCellsByTypeHash(typeHash: "0x6c5b2cd24ce7cbc16ff368d116294b3c8e5e4f33197900396e9a35d52d8c0f83", from: 1, to: 100)
        XCTAssertNotNil(result)
    }

    func testGetCurrentCell() throws {
        let client = APIClient()
        let cells = try client.getCellsByTypeHash(typeHash: "0x6c5b2cd24ce7cbc16ff368d116294b3c8e5e4f33197900396e9a35d52d8c0f83", from: 1, to: 100)
        let result = try client.getCurrentCell(outPoint: cells.first!.outPoint)
        XCTAssertNotNil(result)
    }

    func testSendTransaction() throws {
        let tx = Transaction(version: 0, deps: [], inputs: [], outputs: [])
        let client = APIClient()
        let result = try client.sendTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }
}
