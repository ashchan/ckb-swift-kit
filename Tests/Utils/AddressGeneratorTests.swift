//
//  AddressGeneratorTests.swift
//
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
            "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            generator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
        XCTAssertEqual(
            "ckt1qyqq96psh4h7rxgjl7mmpvf5e0jnz79earcsyrlxrx",
            generator.address(for: "0x0331b3c0225388c5010e3507beb28ecf409c022ef6f358f02b139cbae082f5a2a3")
        )
        XCTAssertEqual(
            "ckt1qyq0phsyqvgkfkzrshphsramyxyz8yew3yzsl76naf",
            generator.address(for: "0x0360bf05c11e7b4ac8de58077554e3d777acd64bf4abb9cd947002eb98a4827bba")
        )
    }

    func testPubkeyToAddressMainnet() {
        let generator = AddressGenerator(network: .mainnet)
        XCTAssertEqual(
            "ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd",
            generator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
    }

    func testPubkeyHashToAddressTestnet() {
        let generator = AddressGenerator(network: .testnet)
        XCTAssertEqual(
            "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            generator.address(publicKeyHash: "0x36c329ed630d6ce750712a477543672adab57f4c")
        )
        XCTAssertEqual(
            "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            generator.address(publicKeyHash: Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"))
        )
    }

    func testPubkeyHashToAddressMainnet() {
        let generator = AddressGenerator(network: .mainnet)
        XCTAssertEqual(
            "ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd",
            generator.address(publicKeyHash: "0x36c329ed630d6ce750712a477543672adab57f4c")
        )
        XCTAssertEqual(
            "ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd",
            generator.address(publicKeyHash: Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"))
        )
    }

    func testPubkeyHashToAddressMainnetRFC() {
        let generator = AddressGenerator(network: .mainnet)
        XCTAssertEqual(
            "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
            generator.address(publicKeyHash: "0x13e41d6F9292555916f17B4882a5477C01270142")
        )
        XCTAssertEqual(
            "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
            generator.address(publicKeyHash: Data(hex: "0x13e41d6F9292555916f17B4882a5477C01270142"))
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
