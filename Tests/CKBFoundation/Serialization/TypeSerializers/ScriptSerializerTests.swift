//
//  ScriptSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class ScriptSerializerTests: XCTestCase {
    func testEmptyScriptHash() {
        let script = Script()
        XCTAssertEqual("0x77c93b0632b5b6c3ef922c5b7cea208fb0a7c427a13d50e13d3fefad17e0c590", script.hash)
    }

    func testDataScriptHash() {
        let script = Script(
            args: "0x",
            codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
            hashType: .data
        )
        XCTAssertEqual("0x4ceaa32f692948413e213ce6f3a83337145bde6e11fd8cb94377ce2637dcc412", script.hash)
    }

    func testTypeScriptHash() {
        let script = Script(
            args: "0x3954acece65096bfa81258983ddb83915fc56bd8",
            codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88",
            hashType: .type
        )
        XCTAssertEqual("0x8a974f98096fd4b9049a787cee968d3869d3274a9b9baf382ad362e864d83798", script.hash)
    }

    func testScriptHashWithZeroCodeHash() {
        let script = Script(
            args: "0x01",
            codeHash: H256.zeroHash
        )
        XCTAssertEqual("0x67951b34bce20cb71b7e235c1f8cda259628d99d94825bffe549c23b4dd2930f", script.hash)
    }

    func testSerialize() {
        let script = Script(
            args: "0x3954acece65096bfa81258983ddb83915fc56bd8",
            codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88",
            hashType: .type
        )
        XCTAssertEqual(
            "4900000010000000300000003100000068d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e8801140000003954acece65096bfa81258983ddb83915fc56bd8",
            script.serialize().toHexString()
        )
    }
}
