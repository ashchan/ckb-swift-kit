//
//  Secp256k1Tests.swift
//  CKBTests
//
//  Created by James Chen on 2019/03/02.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class Secp256k1Tests: XCTestCase {
    func testPrivateToPublic() {
        // Default is compressed
        let privateKey = Data(hex: "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let publicKey = Data(hex: "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        XCTAssertEqual(publicKey, Secp256k1.privateToPublic(privateKey: privateKey))
    }

    func testPrivateToPublicCompressed() {
        let privateKey = Data(hex: "1111111111111111111111111111111111111111111111111111111111111111")
        let publicKey = Data(hex: "034f355bdcb7cc0af728ef3cceb9615d90684bb5b2ca5f859ab0f0b704075871aa")
        XCTAssertEqual(publicKey, Secp256k1.privateToPublic(privateKey: privateKey, compressed: true))
    }

    func testPrivateToPublicUncompressed() {
        let privateKey = Data(hex: "1111111111111111111111111111111111111111111111111111111111111111")
        let publicKey = Data(hex: "044f355bdcb7cc0af728ef3cceb9615d90684bb5b2ca5f859ab0f0b704075871aa385b6b1b8ead809ca67454d9683fcf2ba03456d6fe2c4abe2b07f0fbdbb2f1c1")
        XCTAssertEqual(publicKey, Secp256k1.privateToPublic(privateKey: privateKey, compressed: false))
    }
}
