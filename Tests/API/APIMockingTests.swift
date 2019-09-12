//
//  APIMockingTests.swift
//
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
        let result = try getClient(json: "genesisBlock").getBlockByNumber(number: "0x0")
        XCTAssertNotNil(result)
        XCTAssertEqual("0x0", result.header.number)
    }

    func testGetCurrentEpoch() throws {
        let result = try getClient(json: "epoch").getCurrentEpoch()
        XCTAssertTrue(UInt64(result.difficulty.dropFirst(2), radix: 16)! >= 0)
    }

    func testGetEpochByNumber() throws {
        let result = try getClient(json: "epoch").getEpochByNumber(number: "0x0")
        XCTAssertNotNil(result)
    }

    func testGetTransaction() throws {
        let result = try getClient(json: "transaction").getTransaction(hash: "0x2505abd12b6353da33152014cabdf68566fea3976986b5da2fd5980940191ef5")
        XCTAssertNotNil(result)
    }

    func testGetCellbaseOutputCapacityDetails() throws {
        let result = try getClient(json: "blockReward").getCellbaseOutputCapacityDetails(blockHash: "0xba0d878d2c3711d38b5ddc2bc917312ca3898cad98457cc7960e28ec31f26e7f")
        XCTAssertNotNil(result)
        XCTAssert(Int64(result!.txFee.dropFirst(2), radix: 16)! >= 0)
    }

    func testGetBlockHash() throws {
        let result = try? getClient(json: "genesisBlockHash").getBlockHash(number: "0x0")
        XCTAssertNotNil(result)
    }

    func testGetTipHeader() throws {
        let result = try getClient(json: "header").getTipHeader()
        XCTAssertNotNil(result)
        XCTAssertTrue(Int64(result.number.dropFirst(2), radix: 16)! >= 0)
    }

    func testGetHeader() throws {
        let hash = "0xd629a10a08fb0f43fcb97e948fc2b6eb70ebd28536490fe3864b0e40d08397d1"
        let result = try getClient(json: "header").getHeader(blockHash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.hash, hash)
    }

    func testGetHeaderByNumber() throws {
        let number = "0x400"
        let result = try getClient(json: "header").getHeaderByNumber(number: number)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.number, number)
    }

    func testGetLiveCell() throws {
        let outPoint = OutPoint(txHash: "0xda27a795e14067e18a0cfc0951571aaca47bd9851adc9bf5baa22cf27c8bcde8", index: "0")
        let result = try getClient(json: "liveCell").getLiveCell(outPoint: outPoint)
        XCTAssertNotNil(result)
    }

    func testGetLiveCellEmpty() throws {
        let outPoint = OutPoint(txHash: "0xda27a795e14067e18a0cfc0951571aaca47bd9851adc9bf5baa22cf27c8bcde8", index: "0")
        let result = try getClient(json: "liveCellEmpty").getLiveCell(outPoint: outPoint)
        XCTAssertNotNil(result)
    }

    func testGetTipBlockNumber() throws {
        let result = try getClient(json: "tipBlockNumber").getTipBlockNumber()
        XCTAssertTrue(Int64(result.dropFirst(2), radix: 16)! > 0)
    }

    func testSendTransactionEmpty() throws {
        let tx = Transaction()
        let result = try? getClient(json: "sendTransactionEmpty").sendTransaction(transaction: tx)
        XCTAssertNil(result)
    }

    func testTxPoolInfo() throws {
        let result = try getClient(json: "txPoolInfo").txPoolInfo()
        XCTAssertNotNil(result)
        XCTAssert(UInt32(result.pending.dropFirst(2), radix: 16)! >= 0)
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

    func testComputeTransactionHash() throws {
        let tx = Transaction(
            cellDeps: [CellDep(outPoint: OutPoint(txHash: "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141", index: "0x0"), depType: .code)],
            headerDeps: ["0xeca4e06e75df81c0247365f864a08c7ef0eec8a5c7d182a25e6c086408a97cd2"],
            inputs: [CellInput(previousOutput: OutPoint(txHash: "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17", index: "0x0"), since: "0x0")],
            outputs: [CellOutput(capacity: "0x174876e800", lock: Script(args: [], codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data))],
            outputsData: ["0x"]
        )
        let result = try? getClient(json: "computeTransactionHash").computeTransactionHash(transaction: tx)
        XCTAssertNotNil(result)
        XCTAssertEqual("0x13ebb4a177fbbbef800f9988cc1763d313cbe76c3aed3f15c6fa93b723d1a070", result)
    }

    func testComputeScriptHash() throws {
        let script = Script(args: [], codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data)
        let result = try? getClient(json: "computeScriptHash").computeScriptHash(script: script)
        XCTAssertNotNil(result)
        XCTAssertEqual("0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", result)
    }
    
    func testDryRunTransaction() throws {
        let tx = Transaction()
        let result = try? getClient(json: "dryRunTransaction").dryRunTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }

    func testIndexLockHash() throws {
        let lockHash = "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9"
        let result = try getClient(json: "indexLockHash").indexLockHash(lockHash: lockHash, indexFrom: "0x400")
        XCTAssertNotNil(result)
        XCTAssertEqual(result.lockHash, lockHash)
    }

    func testDeindexLockHash() throws {
        let lockHash = "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9"
        let result = try getClient(json: "deindexLockHash").deindexLockHash(lockHash: lockHash)
        XCTAssertNil(result)
    }

    func testGetLockHashIndexStates() throws {
        let result = try getClient(json: "getLockHashIndexStates").getLockHashIndexStates()
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testGetLiveCellsByLockHash() throws {
        let result = try getClient(json: "getLiveCellsByLockHash").getLiveCellsByLockHash(lockHash: "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", page: "0x0", pageSize: "0x2", reverseOrder: false)
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testGetTransactionssByLockHash() throws {
        let result = try getClient(json: "getTransactionsByLockHash").getTransactionsByLockHash(lockHash: "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", page: "0x0", pageSize: "0x2", reverseOrder: false)
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
