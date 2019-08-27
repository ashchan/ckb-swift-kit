//
//  ScriptTests.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ScriptTests: XCTestCase {
    func testEmptyScriptHash() {
        let script = Script()
        XCTAssertEqual("0xc371c8d6a0aed6018e91202d047c35055cfb0228e6709f1cd1d5f756525628b9", script.hash)
    }

    // TODO: Enable this test after script serialization is implemented
    func _testScriptHash() {
        let script = Script(
            args: [],
            codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5",
            hashType: .data
        )
        XCTAssertEqual("0xd8753dd87c7dd293d9b64d4ca20d77bb8e5f2d92bf08234b026e2d8b1b00e7e9", script.hash)
    }

    func testScriptHashWithZeroCodeHash() {
        let script = Script(
            args: ["0x01"],
            codeHash: H256.zeroHash
        )
        XCTAssertEqual("0xcd5b0c29b8f5528d3a75e3918576db4d962a1d4b315dff7d3c50818cc373b3f5", script.hash)
    }

    func testCodeHashHasPrefix() {
        let codeHash = Utils.prefixHex(H256.zeroHash)
        let script = Script(codeHash: H256(codeHash.dropFirst(2)))
        XCTAssertEqual(codeHash, script.codeHash)
        XCTAssertEqual(codeHash, script.param["code_hash"] as! H256)
    }
}
