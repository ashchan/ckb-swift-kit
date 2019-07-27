//
//  Secp256k1Tests.swift
//
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

    func testPrivateToPublicFixture() {
        let vectors = TestHelper.load(json: "pubkey")["vectors"] as! [[String: String]]
        vectors.forEach { (testcase) in
            let privateKey = Data(hex: testcase["seckey"]!)
            let pubkey = Data(hex: testcase["pubkey"]!)
            let compressed = Data(hex: testcase["compressed"]!)
            XCTAssertEqual(pubkey, Secp256k1.privateToPublic(privateKey: privateKey, compressed: false))
            XCTAssertEqual(compressed, Secp256k1.privateToPublic(privateKey: privateKey, compressed: true))
        }
    }

    func testSign() {
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let message = Data(hex: "0x95e919c41e1ae7593730097e9bb1185787b046ae9f47b4a10ff4e22f9c3e3eab")
        let signed = Data(hex: "0x304402201e94db61cff452639cf7dd991cf0c856923dcf74af24b6f575b91479ad2c8ef402200769812d1cf1fd1a15d2f6cb9ef3d91260ef27e65e1f9be399887e9a54477863")
        XCTAssertEqual(signed, Secp256k1.sign(privateKey: privateKey, data: message))
    }

    func testSignFixture() {
        let vectors = TestHelper.load(json: "ecdsa_sig")["vectors"] as! [[String: String]]
        vectors.forEach { (testcase) in
            let privateKey = Data(hex: testcase["privkey"]!)
            let message = Data(hex: testcase["msg"]!)
            let expected = Data(hex: testcase["sig"]!).dropLast(1)
            let signed = Secp256k1.sign(privateKey: privateKey, data: message)
            XCTAssertEqual(signed, expected)
        }
    }

    func testSignRecoverable() {
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let message = Data(hex: "0x95e919c41e1ae7593730097e9bb1185787b046ae9f47b4a10ff4e22f9c3e3eab")
        let signed = Data(hex: "0x1e94db61cff452639cf7dd991cf0c856923dcf74af24b6f575b91479ad2c8ef40769812d1cf1fd1a15d2f6cb9ef3d91260ef27e65e1f9be399887e9a5447786301")
        XCTAssertEqual(signed, Secp256k1.signRecoverable(privateKey: privateKey, data: message))
    }
}
