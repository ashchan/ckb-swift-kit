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
    func testPublicKeyHash() {
        let generator = AddressGenerator(network: .testnet)
        let hash = generator.hash(for: Data(hex: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"))
        XCTAssertEqual(Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"), hash)
    }

    func testPubkeyToAddressTestnet() {
        let generator = AddressGenerator(network: .testnet)
        XCTAssertEqual(
            "ckt1q9gry5zgxmpjnmtrp4kww5r39frh2sm89tdt2l6v234ygf",
            generator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
        XCTAssertEqual(
            "ckt1q9gry5zgqt5rp0t0uxv39lahkzcnfjl9x9utn683yv9zxs",
            generator.address(for: "0x0331b3c0225388c5010e3507beb28ecf409c022ef6f358f02b139cbae082f5a2a3")
        )
        XCTAssertEqual(
            "ckt1q9gry5zg7r0qgqc3vnvy8pwr0q8mkgvgywfjazg9xlz2ev",
            generator.address(for: "0x0360bf05c11e7b4ac8de58077554e3d777acd64bf4abb9cd947002eb98a4827bba")
        )
    }

    func testPubkeyToAddressMainnet() {
        let generator = AddressGenerator(network: .mainnet)
        XCTAssertEqual(
            "ckb1q9gry5zgxmpjnmtrp4kww5r39frh2sm89tdt2l6vqdd7em",
            generator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
    }

    func testPubkeyHashToAddressTestnet() {
        let generator = AddressGenerator(network: .testnet)
        XCTAssertEqual(
            "ckt1q9gry5zgxmpjnmtrp4kww5r39frh2sm89tdt2l6v234ygf",
            generator.address(publicKeyHash: "0x36c329ed630d6ce750712a477543672adab57f4c")
        )
        XCTAssertEqual(
            "ckt1q9gry5zgxmpjnmtrp4kww5r39frh2sm89tdt2l6v234ygf",
            generator.address(publicKeyHash: Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"))
        )
    }

    func testPubkeyHashToAddressMainnet() {
        let generator = AddressGenerator(network: .mainnet)
        XCTAssertEqual(
            "ckb1q9gry5zgxmpjnmtrp4kww5r39frh2sm89tdt2l6vqdd7em",
            generator.address(publicKeyHash: "0x36c329ed630d6ce750712a477543672adab57f4c")
        )
        XCTAssertEqual(
            "ckb1q9gry5zgxmpjnmtrp4kww5r39frh2sm89tdt2l6vqdd7em",
            generator.address(publicKeyHash: Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"))
        )
    }

    func testAddressToPubkeyHash() {
        let publicKey = "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"
        let generator = AddressGenerator(network: .testnet)
        let address = generator.address(for: publicKey)
        XCTAssertEqual(
            generator.hash(for: Data(hex: publicKey)).toHexString(),
            generator.publicKeyHash(for: address)
        )
        XCTAssertNil(generator.publicKeyHash(for: "bbbbb"))
    }
}
