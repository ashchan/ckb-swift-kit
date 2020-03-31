//
//  APIMockingTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
import CKBFoundation
@testable import CKBKit

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
        let result = try getClient(json: "genesisBlock").getBlockByNumber(number: 0)
        XCTAssertNotNil(result)
        XCTAssertEqual(0, result.header.number)
    }

    func testGetCurrentEpoch() throws {
        let result = try getClient(json: "epoch").getCurrentEpoch()
        XCTAssertTrue(result.compactTarget >= 0)
    }

    func testGetEpochByNumber() throws {
        let result = try getClient(json: "epoch").getEpochByNumber(number: 0)
        XCTAssertNotNil(result)
    }

    func testGetTransaction() throws {
        let result = try getClient(json: "transaction").getTransaction(hash: "0x2505abd12b6353da33152014cabdf68566fea3976986b5da2fd5980940191ef5")
        XCTAssertNotNil(result)
    }

    func testGetCellbaseOutputCapacityDetails() throws {
        let result = try getClient(json: "blockReward").getCellbaseOutputCapacityDetails(blockHash: "0xba0d878d2c3711d38b5ddc2bc917312ca3898cad98457cc7960e28ec31f26e7f")
        XCTAssertNotNil(result)
        XCTAssert(result!.txFee >= 0)
    }

    func testGetBlockHash() throws {
        let result = try? getClient(json: "genesisBlockHash").getBlockHash(number: 0)
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
        let result = try getClient(json: "header").getTipHeader()
        XCTAssertNotNil(result)
        XCTAssertTrue(result.number >= 0)
    }

    func testGetHeader() throws {
        let hash = "0x70396940ae2e81bd2627a8e0e75f3d277585bb1afd78839cfd8f2c54e8697bbc"
        let result = try getClient(json: "header").getHeader(blockHash: hash)
        XCTAssertNotNil(result)
    }

    func testGetHeaderByNumber() throws {
        let number = BlockNumber(1024)
        let result = try getClient(json: "header").getHeaderByNumber(number: number)
        XCTAssertNotNil(result)
    }

    func testGetLiveCell() throws {
        let outPoint = OutPoint(txHash: "0xda27a795e14067e18a0cfc0951571aaca47bd9851adc9bf5baa22cf27c8bcde8", index: 0)
        let result = try getClient(json: "liveCell").getLiveCell(outPoint: outPoint)
        XCTAssertNotNil(result)
    }

    func testGetLiveCellEmpty() throws {
        let outPoint = OutPoint(txHash: "0xda27a795e14067e18a0cfc0951571aaca47bd9851adc9bf5baa22cf27c8bcde8", index: 0)
        let result = try getClient(json: "liveCellEmpty").getLiveCell(outPoint: outPoint)
        XCTAssertNotNil(result)
    }

    func testGetTipBlockNumber() throws {
        let result = try getClient(json: "tipBlockNumber").getTipBlockNumber()
        XCTAssertTrue(result > 0)
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

    func testGetBlockchainInfo() throws {
        let result = try getClient(json: "blockchainInfo").getBlockchainInfo()
        XCTAssertNotNil(result)
        XCTAssertFalse(result.chain.isEmpty)
    }

    func testGetPeersState() throws {
        let result = try getClient(json: "peersState").getPeersState()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
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

    func testSetBan() throws {
        let result = try getClient(json: "setBan").setBan(address: "192.168.0.1", command: "insert", banTime: nil, absolute: nil, reason: "a reason")
        XCTAssertNil(result)
    }

    func testGetBannedAddress() throws {
        let result = try getClient(json: "getBannedAddresses").getBannedAddresses()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }
}

extension APIMockingClient {
    convenience init(_ jsonPath: String) {
        self.init(url: APIClient.defaultLocalURL)

        mockingData = TestHelper.load(json: jsonPath)
    }
}

private extension APIMockingTests {
    func getClient(json: String) -> APIClient {
        return APIMockingClient(json)
    }
}
