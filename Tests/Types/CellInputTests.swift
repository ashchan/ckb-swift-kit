//
//  CellInputTests.swift
//  CKBTests
//
//  Created by James Chen on 2019/06/05.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class CellInputTests: XCTestCase {
    func testParam() {
        let input = CellInput(
            previousOutput: OutPoint(blockHash: H256.zeroHash),
            since: "0"
        )
        let blockHash = (input.param["previous_output"] as! [String: Any])["block_hash"] as! String
        XCTAssertEqual(blockHash, H256.zeroHash)
        XCTAssertEqual(input.param["since"] as! Number, "0")
    }
}
