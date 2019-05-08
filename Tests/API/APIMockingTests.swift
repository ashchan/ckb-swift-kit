//
//  APIMockingTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/04/29.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class APIMockingTests: XCTestCase {
    func testGenesisBlockHash() {
        let result = try? getClient(json: "genesisBlockHash").genesisBlockHash()
        XCTAssertNotNil(result)
    }

    func testGetBlock() throws {
        let hash = try getClient(json: "genesisBlockHash").genesisBlockHash()
        let result = try getClient(json: "genesisBlock").getBlock(hash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(hash, result.header.hash)
    }

    func testGetBlockByNumber() throws {
        let result = try getClient(json: "genesisBlock").getBlockByNumber(number: "0")
        XCTAssertNotNil(result)
        XCTAssertEqual("0", result.header.number)
    }

    func testGetCurrentEpoch() throws {
        let result = try getClient(json: "epoch").getCurrentEpoch()
        XCTAssertTrue(UInt64(result.difficulty.dropFirst(2), radix: 16)! >= 0)
    }

    func testGetEpochByNumber() throws {
        let result = try getClient(json: "epoch").getEpochByNumber(number: "0")
        XCTAssertNotNil(result)
    }

    func testGetTransaction() throws {
        let result = try getClient(json: "transaction").getTransaction(hash: "0x2505abd12b6353da33152014cabdf68566fea3976986b5da2fd5980940191ef5")
        XCTAssertNotNil(result)
    }

    func testGetBlockHash() throws {
        let result = try? getClient(json: "genesisBlockHash").getBlockHash(number: "0")
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
        let result = try getClient(json: "tipHeader").getTipHeader()
        XCTAssertNotNil(result)
        XCTAssertTrue(Int64(result.number)! > 0)
    }

    func testGetLiveCell() throws {
        let outPoint = OutPoint(
            blockHash: "0x4c2f8ba5f5a0104eaf84fcbb16af4b0e7ca2f2fdb076e748d54ef876d085d49e",
            cell: CellOutPoint(txHash: "0xda27a795e14067e18a0cfc0951571aaca47bd9851adc9bf5baa22cf27c8bcde8", index: 0)
        )
        let result = try getClient(json: "liveCellEmpty").getLiveCell(outPoint: outPoint)
        XCTAssertNotNil(result)
    }

    func testGetTipBlockNumber() throws {
        let result = try getClient(json: "tipBlockNumber").getTipBlockNumber()
        XCTAssertTrue(Int64(result)! > 0)
    }

    func testSendTransactionEmpty() throws {
        let tx = Transaction()
        let result = try? getClient(json: "sendTransactionEmpty").sendTransaction(transaction: tx)
        XCTAssertNil(result)
    }

    func testTxPoolInfo() throws {
        let result = try getClient(json: "txPoolInfo").txPoolInfo()
        XCTAssertNotNil(result)
        XCTAssert(result.pending >= 0)
    }

    func testLocalNodeInfo() throws {
        let result = try getClient(json: "localNodeInfo").localNodeInfo()
        XCTAssertFalse(result.addresses.isEmpty)
        XCTAssertFalse(result.nodeId.isEmpty)
    }

    func testGetPeers() throws {
        let result = try getClient(json: "peers").getPeers()
        XCTAssertNotNil(result)
        XCTAssertFalse(result.first!.addresses.isEmpty)
    }

    func testTraceTransactionEmpty() throws {
        let tx = Transaction(deps: [], inputs: [], outputs: [], witnesses: [])
        let result = try? getClient(json: "traceTransactionEmpty").traceTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }
}

extension APIMockingClient {
    convenience init(_ jsonPath: String) {
        self.init(url: APIClient.defaultLocalURL)

        let path = Bundle(for: type(of: self)).path(forResource: jsonPath, ofType: "json")!
        mockingData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
}

private extension APIMockingTests {
    func getClient(json: String) -> APIClient {
        return APIMockingClient(json)
    }
}