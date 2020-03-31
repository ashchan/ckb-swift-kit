//
//  APIClientTests.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
import CKBFoundation
@testable import CKBKit

class APIClientTests: RPCTestSkippable {
    func testSettingId() throws {
        let result = try client.load(APIRequest<H256>(id: "10", method: "get_block_hash", params: ["0x0"]))
        XCTAssertNotNil(result)
    }

    func testGenesisBlockHash() {
        let result = try? client.genesisBlockHash()
        XCTAssertNotNil(result)
    }

    func testGenesisBlock() throws {
        let result = try client.genesisBlock()
        XCTAssertNotNil(result)
    }

    func testGetBlock() throws {
        let hash = try client.genesisBlockHash()
        let result = try client.getBlock(hash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(hash, result.header.hash)

        XCTAssertNil(try? client.getBlock(hash: nonexistentHash))
    }

    func testGetBlockByNumber() throws {
        let result = try client.getBlockByNumber(number: 0)
        XCTAssertNotNil(result)
        XCTAssertEqual(0, result.header.number)
    }

    func testGetBlockPerformance() throws {
        measure {
            _ = try! client.genesisBlock()
        }
    }

    func testGetTransaction() throws {
        let genesisBlock = try client.genesisBlock()
        if let tx = genesisBlock.transactions.first {
            let result = try client.getTransaction(hash: tx.hash)
            XCTAssertNotNil(result)
            XCTAssertEqual(tx.hash, result.transaction.hash)
        }

        XCTAssertNil(try? client.getTransaction(hash: nonexistentHash))
    }

    func testGetCellbaseOutputCapacityDetails() throws {
        let tipHeader = try client.getTipHeader()
        let result = try client.getCellbaseOutputCapacityDetails(blockHash: tipHeader.hash)
        if let result = result {
            XCTAssert(result.txFee >= 0)
        }
    }

    func testGetBlockHash() throws {
        let result = try client.getBlockHash(number: 0)
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
        let result = try client.getTipHeader()
        XCTAssertNotNil(result)
        XCTAssertTrue(result.number >= 0)
    }

    func testGetHeader() throws {
        let tipHeader = try client.getTipHeader()
        let hash = tipHeader.hash
        let result = try client.getHeader(blockHash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.hash, hash)
    }

    func testGetHeaderByNumber() throws {
        let tipHeader = try client.getTipHeader()
        let number = tipHeader.number
        let result = try client.getHeaderByNumber(number: number)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.number, number)
    }

    func testGetCellsByLockHash() throws {
        let result = try client.getCellsByLockHash(lockHash: "0x321c1ca2887fb8eddaaa7e917399f71e63e03a1c83ff75ed12099a01115ea2ff", from: 1, to: 100)
        XCTAssertNotNil(result)

        XCTAssertTrue(try client.getCellsByLockHash(lockHash: nonexistentHash, from: 1, to: 100).isEmpty)
    }

    func testGetLiveCell() throws {
        let cells = try client.getCellsByLockHash(lockHash: "0x321c1ca2887fb8eddaaa7e917399f71e63e03a1c83ff75ed12099a01115ea2ff", from: 1, to: 100)
        if let cell = cells.first {
            let result = try client.getLiveCell(outPoint: cell.outPoint)
            XCTAssertNotNil(result)
        }

        XCTAssertTrue(try client.getCellsByLockHash(lockHash: nonexistentHash, from: 1, to: 100).isEmpty)
    }

    func testGetTipBlockNumber() throws {
        let result = try client.getTipBlockNumber()
        XCTAssertTrue(result >= 0)
    }

    func testGetCurrentEpoch() throws {
        let result = try client.getCurrentEpoch()
        XCTAssertTrue(result.number >= 0)
    }

    func testGetEpochByNumber() throws {
        let number = try client.getCurrentEpoch().number
        let result = try client.getEpochByNumber(number: number)
        XCTAssertNotNil(result)

        XCTAssertNil(try? client.getEpochByNumber(number: number + 10_000))
    }

    func testSendTransactionEmpty() throws {
        let tx = Transaction()
        let result = try? client.sendTransaction(transaction: tx)
        XCTAssertNil(result)
    }

    func testTxPoolInfo() throws {
        let result = try client.txPoolInfo()
        XCTAssertNotNil(result)
        XCTAssert(result.pending >= 0)
    }

    func testGetBlockchainInfo() throws {
        let result = try client.getBlockchainInfo()
        XCTAssertNotNil(result)
        XCTAssertFalse(result.chain.isEmpty)
    }

    func testGetPeersState() throws {
        let result = try client.getPeersState()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testLocalNodeInfo() throws {
        let result = try client.localNodeInfo()
        XCTAssertFalse(result.addresses.isEmpty)
        XCTAssertFalse(result.nodeId.isEmpty)
    }

    func testGetPeers() throws {
        let result = try client.getPeers()
        XCTAssertNotNil(result)
    }

    func testSetBan() throws {
        let result = try client.setBan(address: "192.168.0.1", command: "insert", banTime: nil, absolute: nil, reason: "a reason")
        XCTAssertNil(result)
    }

    func testGetBannedAddress() throws {
        let result = try client.getBannedAddresses()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }
}

private extension APIClientTests {
    var node: URL {
        return APIClient.defaultLocalURL
    }

    var client: APIClient {
        return APIClient(url: node)
    }

    var nonexistentHash: H256 {
        return "0x00000000000000000000000067d82224e6619896c7f12bb73a14dd9329af9c8d"
    }
}
