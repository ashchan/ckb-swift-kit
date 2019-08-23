//
//  APIClientTests.swift
//
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

    func testGetCellbaseOutputCapacityDetails() throws {
        let tipHeader = try client.getTipHeader()
        let result = try client.getCellbaseOutputCapacityDetails(blockHash: tipHeader.hash)
        if let result = result {
            XCTAssert(Int64(result.txFee)! >= 0)
        }
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

    func testSetBan() throws {
        let result = try client.setBan(address: "192.168.0.1", command: "insert", banTime: nil, absolute: nil, reason: "a reason")
        XCTAssertNil(result)
    }

    func testGetBannedAddress() throws {
        let result = try client.getBannedAddresses()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testComputeTransactionHash() throws {
        let tx = Transaction(
            cellDeps: [CellDep(outPoint: OutPoint(txHash: "0xca457e8f2babbced0321daa535d5d357f554ff601a164c3ce76b547fd5ad2452", index: "0"), isDepGroup: false)],
            headerDeps: ["0x83fefed5da7a3008e61c2e2d7809f07fc3beb66c5b226567d4f39fc062aa4d3d"],
            inputs: [CellInput(previousOutput: OutPoint(txHash: "0xd134dabdb4686abd4e25b0fc95d5b7da5e14efc87e99bd34965571725f6370e3", index: "0"), since: "0")],
            outputs: [CellOutput(capacity: "100000000000", lock: Script(args: [], codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data))],
            outputsData: ["0x"]
        )
        let result = try client.computeTransactionHash(transaction: tx)
        XCTAssertNotNil(result)
        XCTAssertEqual("0xc04334858620b70b60daa7e36c8daabb782af75e4aba7fa96e4f6f6ad2b000b3", result)
    }

    func testComputeScriptHash() throws {
        let script = Script(args: [], codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data)
        let result = try client.computeScriptHash(script: script)
        XCTAssertNotNil(result)
        XCTAssertEqual("0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", result)
    }

    func testDryRunTransaction() throws {
        let tx = Transaction()
        let result = try client.dryRunTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }

    func testIndexLockHash() throws {
        let lockHash = "0x9a9a6bdbc38d4905eace1822f85237e3a1e238bb3f277aa7b7c8903441123510"
        var result = try client.indexLockHash(lockHash: lockHash, indexFrom: "0")
        XCTAssertNotNil(result)
        XCTAssertEqual(result.lockHash, lockHash)
        XCTAssertEqual(result.blockNumber, "0")

        result = try client.indexLockHash(lockHash: lockHash)
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
