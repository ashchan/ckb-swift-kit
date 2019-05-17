//
//  ScriptTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/26.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ScriptTests: XCTestCase {
    func testEmptyScriptHash() {
        let script = Script()
        XCTAssertEqual("0x266cec97cbede2cfbce73666f08deed9560bdf7841a7a5a51b3a3f09da249e21", script.hash)
    }

    func testScriptHash() {
        let script = Script(
            args: ["0x01"],
            codeHash: H256.zeroHash
        )
        XCTAssertEqual("0xdade0e507e27e2a5995cf39c8cf454b6e70fa80d03c1187db7a4cb2c9eab79da", script.hash)
    }

    func testCodeHashHasPrefix() {
        let codeHash = Utils.prefixHex(H256.zeroHash)
        let script = Script(codeHash: H256(codeHash.dropFirst(2)))
        XCTAssertEqual(codeHash, script.codeHash)
        XCTAssertEqual(codeHash, script.param["code_hash"] as! H256)
    }
}
