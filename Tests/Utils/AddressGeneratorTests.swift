//
//  AddressGeneratorTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class AddressGeneratorTests: XCTestCase {
    func testPublicKeyHash() {
        let hash = AddressGenerator.hash(for: Data(hex: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"))
        XCTAssertEqual(Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"), hash)
    }

    func testPubkeyToAddressTestnet() {
        XCTAssertEqual(
            "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            AddressGenerator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        )
        XCTAssertEqual(
            "ckt1qyqq96psh4h7rxgjl7mmpvf5e0jnz79earcsyrlxrx",
            AddressGenerator.address(for: "0x0331b3c0225388c5010e3507beb28ecf409c022ef6f358f02b139cbae082f5a2a3")
        )
        XCTAssertEqual(
            "ckt1qyq0phsyqvgkfkzrshphsramyxyz8yew3yzsl76naf",
            AddressGenerator.address(for: "0x0360bf05c11e7b4ac8de58077554e3d777acd64bf4abb9cd947002eb98a4827bba")
        )
    }

    func testPubkeyToAddressMainnet() {
        XCTAssertEqual(
            "ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd",
            AddressGenerator.address(for: "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01", network: .mainnet)
        )
    }

    func testPubkeyHashToAddressTestnet() {
        XCTAssertEqual(
            "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            AddressGenerator.address(publicKeyHash: "0x36c329ed630d6ce750712a477543672adab57f4c")
        )
        XCTAssertEqual(
            "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            AddressGenerator.address(publicKeyHash: Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"))
        )
    }

    func testPubkeyHashToAddressMainnet() {
        XCTAssertEqual(
            "ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd",
            AddressGenerator.address(publicKeyHash: "0x36c329ed630d6ce750712a477543672adab57f4c", network: .mainnet)
        )
        XCTAssertEqual(
            "ckb1qyqrdsefa43s6m882pcj53m4gdnj4k440axqdt9rtd",
            AddressGenerator.address(publicKeyHash: Data(hex: "0x36c329ed630d6ce750712a477543672adab57f4c"), network: .mainnet)
        )
    }

    func testPubkeyHashToAddressMainnetRFC() {
        XCTAssertEqual(
            "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
            AddressGenerator.address(publicKeyHash: "0x13e41d6F9292555916f17B4882a5477C01270142", network: .mainnet)
        )
        XCTAssertEqual(
            "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
            AddressGenerator.address(publicKeyHash: Data(hex: "0x13e41d6F9292555916f17B4882a5477C01270142"), network: .mainnet)
        )
    }

    func testAddressToPubkeyHash() {
        let publicKey = "0x024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"
        let address = AddressGenerator.address(for: publicKey)
        XCTAssertEqual(
            AddressGenerator.hash(for: Data(hex: publicKey)).toHexString(),
            AddressGenerator.publicKeyHash(for: address)
        )
        XCTAssertNil(AddressGenerator.publicKeyHash(for: "bbbbb"))
    }

    func testValidate() {
        XCTAssertTrue(AddressGenerator.validate("ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p"))
        XCTAssertTrue(AddressGenerator.validate("ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83"))

        XCTAssertFalse(AddressGenerator.validate("ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu8i")) // Wrong checksum
        XCTAssertFalse(AddressGenerator.validate("ckt1qyqrdaefa43s6m882pcj53m4gdnj4k440axqswmu83")) // None Bech32 character
        XCTAssertFalse(AddressGenerator.validate("tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7")) // None ckt/ckb addresses
    }
}
