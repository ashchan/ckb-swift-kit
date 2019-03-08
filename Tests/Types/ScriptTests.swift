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
    // Skipped
    func x_testAlwaysSuccessScriptTypeHash() throws {
        let client = APIClient()
        let script = Script(
            version: 0,
            binary: nil,
            reference: try client.alwaysSuccessCellHash(),
            signedArgs: [],
            args: []
        )
        XCTAssertEqual("0x0da2fe99fe549e082d4ed483c2e968a89ea8d11aabf5d79e5cbf06522de6e674", script.typeHash)
    }

    func testAlwaysSuccessScriptTypeHash() throws {
        let client = APIClient()
        let script = Script(
            version: 0,
            binary: client.alwaysSuccessCellBytes.toHexString(),
            reference: nil,
            signedArgs: [],
            args: []
        )
        XCTAssertEqual("0x9f94d2511b787387638faa4a5bfd448baf21aa5fde3afaa54bb791188b5cf002", script.typeHash)
    }

    func testEmptyScriptTypeHash() throws {
        let script = Script(
            version: 0,
            binary: nil,
            reference: nil,
            signedArgs: [],
            args: []
        )
        XCTAssertEqual("0x4b29eb5168ba6f74bff824b15146246109c732626abd3c0578cbf147d8e28479", script.typeHash)
    }

    func testScriptTypeHash() throws {
        let script = Script(
            version: 0,
            binary: "0x01",
            reference: "0x0000000000000000000000000000000000000000000000000000000000000000",
            signedArgs: ["0x01"],
            args: ["0x01"]
        )
        XCTAssertEqual("0xafb140d0673571ed5710d220d6146d41bd8bc18a3a4ff723dad4331da5af5bb6", script.typeHash)
    }
}
