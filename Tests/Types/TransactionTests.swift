//
//  TransactionTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class TransactionTests: XCTestCase {
    func testParam() {
        let tx = Transaction(
            version: "0",
            deps: [
                OutPoint(blockHash: nil, cell: CellOutPoint(txHash: "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a", index: "1"))
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(blockHash: nil, cell: CellOutPoint(txHash: "0xa80a8e01d45b10e1cbc8a2557c62ba40edbdc36cd63a31fc717006ca7b157b50", index: "0")),
                    since: "0"
                )
            ],
            outputs: [
                CellOutput(
                    capacity: "100000000000",
                    data: "0x",
                    lock: Script(args: ["0xe2193df51d78411601796b35b17b4f8f2cd85bd0"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: "4900000000000",
                    data: "0x",
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                )
            ],
            witnesses: [
                Witness(data: [])
            ]
        )
        let version = tx.param["version"] as! String
        XCTAssertEqual(version, "0")
        let deps = tx.param["deps"] as! [[String: Any]]
        XCTAssertEqual(
            (deps.first!["cell"] as! [String: Any])["tx_hash"] as! String,
            "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a"
        )
    }
}
