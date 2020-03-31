//
//  CellInputTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class CellInputTests: XCTestCase {
    func testParam() {
        let input = CellInput(
            previousOutput: OutPoint(txHash: H256.zeroHash, index: 0),
            since: 0
        )
        let txHash = (input.param["previous_output"] as! [String: Any])["tx_hash"] as! String
        XCTAssertEqual(txHash, H256.zeroHash)
        XCTAssertEqual(input.param["since"] as! String, "0x0")
    }
}
