//
//  CellOutputTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class CellOutputTests: XCTestCase {
    func testParam() {
        let output = CellOutput(
            capacity: 100000,
            lock: Script(args: "0x", codeHash: "0x")
        )
        XCTAssertEqual(output.param["capacity"] as! String, "0x186a0")
    }

    func testParamWithType() {
        let output = CellOutput(
            capacity: 100000,
            lock: Script(args: "0x", codeHash: "0x"),
            type: Script(args: "0xabcd", codeHash: "0x")
        )
        let args = (output.param["type"] as! [String: Any])["args"] as! HexString
        XCTAssertEqual(args, "0xabcd")
    }
}
