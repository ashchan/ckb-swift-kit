//
//  CellOutputTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/06/05.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class CellOutputTests: XCTestCase {
    func testParam() {
        let output = CellOutput(
            capacity: "100000",
            data: "0x",
            lock: Script(args: [], codeHash: "0x")
        )
        XCTAssertEqual(output.param["capacity"] as! Capacity, "100000")
    }

    func testParamWithType() {
        let output = CellOutput(
            capacity: "100000",
            data: "0x",
            lock: Script(args: [], codeHash: "0x"),
            type: Script(args: ["0xabcd"], codeHash: "0x")
        )
        let args = (output.param["type"] as! [String: Any])["args"] as! [HexString]
        XCTAssertEqual(args.first!, "0xabcd")
    }
}
