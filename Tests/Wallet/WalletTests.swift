//
//  WalletTests.swift
//  CKBTests
//
//  Created by 翟泉 on 2019/3/28.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class WalletTests: XCTestCase {
    var api: APIClient!
    var wallet: Wallet!
    var asw: AlwaysSuccessWallet!

    override func invokeTest() {
        if ProcessInfo().environment["SKIP_RPC_TESTS"] == "1" {
            return
        }
        super.invokeTest()
    }

    override func setUp() {
        api = APIClient()
        api.setMrubyConfig(
            outPoint: OutPoint(hash: "0xe33e7492d412979a96f55c9158aa89b7ae96ffa6410055bd63ff4a171b936b8b", index: 0),
            cellHash: "0x00ccb858f841db7ece8833a77de158b84af4c8f43a69dbb0f43de87faabfde32"
        )
        wallet = Wallet(privateKey: "d905b41470ec57cf469b250cf1dafb56014aaf9b6ade23738be52555e1dab4f2", api: api)
        asw = try? AlwaysSuccessWallet(api: api)
    }

    func testAddress() {
        XCTAssertEqual(wallet.address, "0x643294a6a893d70d9588dc0a414493242765ee99691dd9866d14094e161e1f66")
    }

    func testAswWalletBalance() throws {
        XCTAssertNotNil(asw)
        XCTAssert(try asw.getBalance() > 0)
    }

    func testAswWalletSendCapacity() throws {
        let privateKey = Utils.generatePrivateKey()
        let wallet = Wallet(privateKey: privateKey, api: api)
        let txhash = try asw.sendCapacity(targetAddress: wallet.address, capacity: 1000)
        print(txhash)
        for _ in 0...20 {
            Thread.sleep(forTimeInterval: 6)
            if (try? api.getTransaction(hash: txhash)) != nil {
                let balance = try wallet.getBalance()
                XCTAssertTrue(balance >= 1000)
                return
            }
        }
        XCTAssert(false, "")
    }
}
