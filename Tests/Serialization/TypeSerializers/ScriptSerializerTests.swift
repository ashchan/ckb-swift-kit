//
//  ScriptSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ScriptSerializerTests: XCTestCase {
    func testEmptyScriptHash() {
        let script = Script()
        XCTAssertEqual("0xbd7e6000ffb8e983a6023809037e0c4cedbc983637c46d74621fd28e5f15fe4f", script.hash)
        let hash = try? APIClient(url: APIClient.defaultLocalURL).computeScriptHash(script: script)
        XCTAssertEqual(script.hash, hash)
    }

    func testDataScriptHash() {
        let script = Script(
            args: [],
            codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
            hashType: .data
        )
        XCTAssertEqual("0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", script.hash)
        let hash = try? APIClient(url: APIClient.defaultLocalURL).computeScriptHash(script: script)
        XCTAssertEqual(script.hash, hash)
    }

    func testTypeScriptHash() {
        let script = Script(
            args: ["0x3954acece65096bfa81258983ddb83915fc56bd8"],
            codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88",
            hashType: .type
        )
        XCTAssertEqual("0xb1ed7d4f2b8a22866391121c504ee88bc1a800024d7aef5fd4219a3cb1c90cb3", script.hash)
        let hash = try? APIClient(url: APIClient.defaultLocalURL).computeScriptHash(script: script)
        XCTAssertEqual(script.hash, hash)
    }

    func testScriptHashWithZeroCodeHash() {
        let script = Script(
            args: ["0x01"],
            codeHash: H256.zeroHash
        )
        XCTAssertEqual("0x5a2b913dfb1b79136fc72a575fd8e93ae080b504463c0066fea086482bfc3a94", script.hash)
        let hash = try? APIClient(url: APIClient.defaultLocalURL).computeScriptHash(script: script)
        XCTAssertEqual(script.hash, hash)
    }

    func testSerialize() {
        let script = Script(
            args: ["0x3954acece65096bfa81258983ddb83915fc56bd8"],
            codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88",
            hashType: .type
        )
        XCTAssertEqual(
            "5100000010000000300000003100000068d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88012000000008000000140000003954acece65096bfa81258983ddb83915fc56bd8",
            script.serialize().toHexString()
        )
    }
}
