//
//  AddressGeneratorTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/04/10.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class AddressGeneratorTests: XCTestCase {
    func testPubkeyHashToAddressTestnet() {
        let generator = AddressGenerator(network: .testnet)
        XCTAssertEqual(
            "ckt1qqqqqqqqqgmvx20dvvxkee6swy4ywa2rvu4d4dtlf3hax6n3f93s23ttk2vdk68gmaq",
            generator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
    }

    func testPubkeyHashToAddressMainnet() {
        let generator = AddressGenerator(network: .mainnet)
        XCTAssertEqual(
            "ckb1qqqqqqqqqgmvx20dvvxkee6swy4ywa2rvu4d4dtlf3hax6n3f93s23ttk2vdk68gmaq",
            generator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
    }
}
