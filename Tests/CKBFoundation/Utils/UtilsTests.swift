//
//  UtilsTests.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class UtilsTests: XCTestCase {
    func testPrivateToPublic() {
        let privateKey = "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3"
        let publicKey = "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"
        XCTAssertEqual(publicKey, Utils.privateToPublic(privateKey))
    }

    func testPrivateToAddress() {
        let privateKey = "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3"
        let address = "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83"
        XCTAssertEqual(address, Utils.privateToAddress(privateKey, network: .testnet))
    }

    func testPublicToAddress() {
        let publicKey = "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"
        let address = "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83"
        XCTAssertEqual(address, Utils.publicToAddress(publicKey, network: .testnet))
    }

    func testPublicKeyHashToAddress() {
        let publicKeyHash = "0x36c329ed630d6ce750712a477543672adab57f4c"
        let address = "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83"
        XCTAssertEqual(address, Utils.publicKeyHashToAddress(publicKeyHash, network: .testnet))
    }

    func testPrefixHex() {
        XCTAssertEqual("0x0001", Utils.prefixHex("0001"))
        XCTAssertEqual("0x0001", Utils.prefixHex("0x0001"))
    }

    func testRemoveHexPrefix() {
        XCTAssertEqual("0001", Utils.removeHexPrefix("0x0001"))
        XCTAssertEqual("0001", Utils.removeHexPrefix("0001"))
    }
}
