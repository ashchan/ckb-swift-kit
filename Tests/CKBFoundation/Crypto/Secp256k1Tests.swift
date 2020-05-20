//
//  Secp256k1Tests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class Secp256k1Tests: XCTestCase {
    func testPrivateToPublic() {
        // Default is compressed
        let privateKey = Data(hex: "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let publicKey = Data(hex: "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        XCTAssertEqual(publicKey, Secp256k1.shared.privateToPublic(privateKey: privateKey))
    }

    func testPrivateToPublicCompressed() {
        let privateKey = Data(hex: "1111111111111111111111111111111111111111111111111111111111111111")
        let publicKey = Data(hex: "034f355bdcb7cc0af728ef3cceb9615d90684bb5b2ca5f859ab0f0b704075871aa")
        XCTAssertEqual(publicKey, Secp256k1.shared.privateToPublic(privateKey: privateKey, compressed: true))
    }

    func testPrivateToPublicUncompressed() {
        let privateKey = Data(hex: "1111111111111111111111111111111111111111111111111111111111111111")
        let publicKey = Data(hex: "044f355bdcb7cc0af728ef3cceb9615d90684bb5b2ca5f859ab0f0b704075871aa385b6b1b8ead809ca67454d9683fcf2ba03456d6fe2c4abe2b07f0fbdbb2f1c1")
        XCTAssertEqual(publicKey, Secp256k1.shared.privateToPublic(privateKey: privateKey, compressed: false))
    }

    /*
    func testPrivateToPublicFixture() {
        let vectors = TestHelper.load(json: "pubkey")["vectors"] as! [[String: String]]
        vectors.forEach { (testcase) in
            let privateKey = Data(hex: testcase["seckey"]!)
            let pubkey = Data(hex: testcase["pubkey"]!)
            let compressed = Data(hex: testcase["compressed"]!)
            XCTAssertEqual(pubkey, Secp256k1.privateToPublic(privateKey: privateKey, compressed: false))
            XCTAssertEqual(compressed, Secp256k1.privateToPublic(privateKey: privateKey, compressed: true))
        }
    }*/

    func testSign() {
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let message = Data(hex: "0x95e919c41e1ae7593730097e9bb1185787b046ae9f47b4a10ff4e22f9c3e3eab")
        let signed = Data(hex: "0x304402201e94db61cff452639cf7dd991cf0c856923dcf74af24b6f575b91479ad2c8ef402200769812d1cf1fd1a15d2f6cb9ef3d91260ef27e65e1f9be399887e9a54477863")
        XCTAssertEqual(signed, Secp256k1.shared.sign(privateKey: privateKey, data: message))
    }

    /*
    func testSignFixture() {
        let vectors = TestHelper.load(json: "ecdsa_sig")["vectors"] as! [[String: String]]
        vectors.forEach { (testcase) in
            let privateKey = Data(hex: testcase["privkey"]!)
            let message = Data(hex: testcase["msg"]!)
            let expected = Data(hex: testcase["sig"]!).dropLast(1)
            let signed = Secp256k1.sign(privateKey: privateKey, data: message)
            XCTAssertEqual(signed, expected)
        }
    }*/

    func testSignRecoverable() {
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let message = Data(hex: "0x95e919c41e1ae7593730097e9bb1185787b046ae9f47b4a10ff4e22f9c3e3eab")
        let signed = Data(hex: "0x1e94db61cff452639cf7dd991cf0c856923dcf74af24b6f575b91479ad2c8ef40769812d1cf1fd1a15d2f6cb9ef3d91260ef27e65e1f9be399887e9a5447786301")
        XCTAssertEqual(signed, Secp256k1.shared.signRecoverable(privateKey: privateKey, data: message))
    }

    func testSeckeyTweakAdd() {
        let privateKey = Data(hex: "0x9e919c96ac5a4caea7ba0ea1f7dd7bca5dca8a11e66ed633690c71e483a6e3c9")
        let tweak = Data(hex: "0x36e92e33659808bf06c3e4302b657f39ca285f6bb5393019bb4e2f7b96e3f914")
        let result = Secp256k1.shared.seckeyTweakAdd(privateKey: privateKey, tweak: tweak)
        XCTAssertEqual("d57acaca11f2556dae7df2d22342fb0427f2e97d9ba8064d245aa1601a8adcdd", result?.toHexString())
    }

    func testPubkeyTweakAdd() {
        let publicKey = Data(hex: "0x03556b2c7e03b12845a973a6555b49fe44b0836fbf3587709fa73bb040ba181b21")
        let tweak = Data(hex: "0x953fd6b91b51605d32a28ab478f39ab53c90103b93bd688330b118c460e9c667")
        let result = Secp256k1.shared.pubkeyTweakAdd(publicKey: publicKey, tweak: tweak)
        XCTAssertEqual("03db6eab66f918e434bae0e24fd73de1a2b293a2af9bd3ad53123996fa94494f37", result?.toHexString())
    }
}
