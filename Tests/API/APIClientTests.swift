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
    override func invokeTest() {
        if ProcessInfo().environment["SKIP_RPC_TESTS"] == "1" {
            return
        }
        super.invokeTest()
    }

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
        XCTAssertEqual(hash, result.header.hash)
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
        if let tx = genesisBlock.commitTransactions.first {
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
        XCTAssertTrue(result.number > 0)
    }

    func testGetCellsByLockHash() throws {
        let client = APIClient()
        let result = try client.getCellsByLockHash(lockHash: "0x321c1ca2887fb8eddaaa7e917399f71e63e03a1c83ff75ed12099a01115ea2ff", from: 1, to: 100)
        XCTAssertNotNil(result)
    }

    func testGetLiveCell() throws {
        let client = APIClient()
        let cells = try client.getCellsByLockHash(lockHash: "0x321c1ca2887fb8eddaaa7e917399f71e63e03a1c83ff75ed12099a01115ea2ff", from: 1, to: 100)
        if let cell = cells.first {
            let result = try client.getLiveCell(outPoint: cell.outPoint)
            XCTAssertNotNil(result)
        }
    }

    func testGetTipBlockNumber() throws {
        let client = APIClient()
        let result = try client.getTipBlockNumber()
        XCTAssertTrue(result > 0)
    }

    func x_testSendTransaction() throws {
        let tx = Transaction()
        let client = APIClient()
        let result = try client.sendTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }

    func testLocalNodeInfo() throws {
        let client = APIClient()
        let result = try client.localNodeInfo()
        XCTAssertFalse(result.addresses.isEmpty)
        XCTAssertFalse(result.nodeId.isEmpty)
    }

    func testGetTransactionTrace() throws {
        let client = APIClient()
        do {
            let _ = try client.getTransactionTrace(hash: "0x1704f772f11c4c2fcb543f22cad66adad5a555e21f14c975c37d1d4bad096d47")
        } catch {
            XCTAssert(true, "Should throw APIError.emptyResponse")
        }
    }

    func x_testTraceTransaction() throws {
        let client = APIClient()
        let tx = Transaction(version: 0, deps: [], inputs: [], outputs: [])
        let result = try client.traceTransaction(transaction: tx)
        XCTAssertFalse(result.isEmpty)
    }
}
