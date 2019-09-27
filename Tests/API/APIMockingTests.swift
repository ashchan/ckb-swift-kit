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
        let result = try getClient(json: "genesisBlock").getBlockByNumber(number: 0)
        XCTAssertNotNil(result)
        XCTAssertEqual(0, result.header.number)
    }

    func testGetCurrentEpoch() throws {
        let result = try getClient(json: "epoch").getCurrentEpoch()
        XCTAssertTrue(UInt64(result.difficulty.dropFirst(2), radix: 16)! >= 0)
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
        let hash = "0x34b9566625faf600fc524930d6fbea62aa0346a66c0de3d227d0025d5971f749"
        let result = try getClient(json: "header").getHeader(blockHash: hash)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.hash, hash)
    }

    func testGetHeaderByNumber() throws {
        let number = BlockNumber(1024)
        let result = try getClient(json: "header").getHeaderByNumber(number: number)
        XCTAssertNotNil(result)
        XCTAssertEqual(result.number, number)
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

    func testComputeTransactionHash() throws {
        let tx = Transaction(
            cellDeps: [CellDep(outPoint: OutPoint(txHash: "0xa4037a893eb48e18ed4ef61034ce26eba9c585f15c9cee102ae58505565eccc3", index: 0), depType: .code)],
            headerDeps: ["0x3ed784b863bc13dbff3f49f4efee16fd0f5b764af7707ab81ae738b7f8475846"],
            inputs: [CellInput(previousOutput: OutPoint(txHash: "0x5169e6406ebed886ea1be802da474e3a46922556f06b1d88b23613f55630fcb4", index: 0), since: 0)],
            outputs: [CellOutput(capacity: 100000000000, lock: Script(args: "0x", codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data))],
            outputsData: ["0x"]
        )
        let result = try? getClient(json: "computeTransactionHash").computeTransactionHash(transaction: tx)
        XCTAssertNotNil(result)
        XCTAssertEqual("0xac963a60263aeb26f3089f0caa58fc081c87f6eb0b8483d840869ae8f34e9559", result)
    }

    func testComputeScriptHash() throws {
        let script = Script(args: "0x", codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data)
        let result = try? getClient(json: "computeScriptHash").computeScriptHash(script: script)
        XCTAssertNotNil(result)
        XCTAssertEqual("0x4ceaa32f692948413e213ce6f3a83337145bde6e11fd8cb94377ce2637dcc412", result)
    }
    
    func testDryRunTransaction() throws {
        let tx = Transaction()
        let result = try? getClient(json: "dryRunTransaction").dryRunTransaction(transaction: tx)
        XCTAssertNotNil(result)
    }

    func testIndexLockHash() throws {
        let lockHash = "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9"
        let result = try getClient(json: "indexLockHash").indexLockHash(lockHash: lockHash, indexFrom: 1024)
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
        let result = try getClient(json: "getLiveCellsByLockHash").getLiveCellsByLockHash(lockHash: "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", page: 0, pageSize: 2, reverseOrder: false)
        XCTAssertNotNil(result)
        XCTAssert(result.count >= 0)
    }

    func testGetTransactionssByLockHash() throws {
        let result = try getClient(json: "getTransactionsByLockHash").getTransactionsByLockHash(lockHash: "0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", page: 0, pageSize: 2, reverseOrder: false)
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
