//
//  APIClientTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/13.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class APIClientTests: RPCTestSkippable {
    func testSettingId() throws {
        let result = try client.load(APIRequest<H256>(id: 10, method: "get_block_hash", params: ["0"]))
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
        let result = try client.getBlockByNumber(number: "0")
        XCTAssertNotNil(result)
        XCTAssertEqual("0", result.header.number)
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

    func testGetBlockHash() throws {
        let result = try client.getBlockHash(number: "0")
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
        let result = try client.getTipHeader()
        XCTAssertNotNil(result)
        XCTAssertTrue(Int64(result.number)! >= 0)
    }

    func testGetCellsByLockHash() throws {
        let result = try client.getCellsByLockHash(lockHash: "0x321c1ca2887fb8eddaaa7e917399f71e63e03a1c83ff75ed12099a01115ea2ff", from: "1", to: "100")
        XCTAssertNotNil(result)

        XCTAssertTrue(try client.getCellsByLockHash(lockHash: nonexistentHash, from: "1", to: "100").isEmpty)
    }

    func testGetLiveCell() throws {
        let cells = try client.getCellsByLockHash(lockHash: "0x321c1ca2887fb8eddaaa7e917399f71e63e03a1c83ff75ed12099a01115ea2ff", from: "1", to: "100")
        if let cell = cells.first {
            let result = try client.getLiveCell(outPoint: cell.outPoint)
            XCTAssertNotNil(result)
        }

        XCTAssertTrue(try client.getCellsByLockHash(lockHash: nonexistentHash, from: "1", to: "100").isEmpty)
    }

    func testGetTipBlockNumber() throws {
        let result = try client.getTipBlockNumber()
        XCTAssertTrue(Int64(result)! >= 0)
    }

    func testGetCurrentEpoch() throws {
        let result = try client.getCurrentEpoch()
        XCTAssertTrue(UInt64(result.difficulty.dropFirst(2), radix: 16)! >= 0)
    }

    func testGetEpochByNumber() throws {
        let number = try client.getCurrentEpoch().number
        let result = try client.getEpochByNumber(number: number)
        XCTAssertNotNil(result)

        XCTAssertNil(try? client.getEpochByNumber(number: String(UInt64(number)! + 10_000)))
    }

    func testSendTransactionEmpty() throws {
        let tx = Transaction()
        let result = try? client.sendTransaction(transaction: tx)
        XCTAssertNil(result)
    }

    func testTxPoolInfo() throws {
        let result = try client.txPoolInfo()
        XCTAssertNotNil(result)
        XCTAssert(UInt32(result.pending)! >= 0)
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

    func testComputeTransactionHash() throws {
        let tx = Transaction()
        let result = try client.computeTransactionHash(transaction: tx)
        XCTAssertNotNil(result)
    }

    func testDryRunTransaction() throws {
        let tx = Transaction()
        let result = try client.dryRunTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }

    func testIndexLockHash() throws {
        let lockHash = "0x9a9a6bdbc38d4905eace1822f85237e3a1e238bb3f277aa7b7c8903441123510"
        let result = try client.indexLockHash(lockHash: lockHash, indexFrom: "0")
        XCTAssertNotNil(result)
        XCTAssertEqual(result.lockHash, lockHash)
    }

    func testDeindexLockHash() throws {
        let lockHash = "0x9a9a6bdbc38d4905eace1822f85237e3a1e238bb3f277aa7b7c8903441123510"
        let result = try client.deindexLockHash(lockHash: lockHash)
        XCTAssertNil(result)
    }

    func testGetLockHashIndexStates() throws {
        let result = try client.getLockHashIndexStates()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testGetLiveCellsByLockHash() throws {
        let result = try client.getLiveCellsByLockHash(lockHash: "0x9a9a6bdbc38d4905eace1822f85237e3a1e238bb3f277aa7b7c8903441123510", page: "0", pageSize: "2", reverseOrder: false)
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testGetTransactionssByLockHash() throws {
        let result = try client.getTransactionsByLockHash(lockHash: "0x9a9a6bdbc38d4905eace1822f85237e3a1e238bb3f277aa7b7c8903441123510", page: "0", pageSize: "2", reverseOrder: false)
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
