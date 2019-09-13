//
//  TransactionSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class TransactionSerializerTests: XCTestCase {
    func testTransaction() {
        let tx = Transaction(
            version: "0x0",
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a", index: "0x0"), depType: .code)
            ],
            outputs: [
                CellOutput(
                    capacity: "100000000000",
                    lock: Script(args: ["0xe2193df51d78411601796b35b17b4f8f2cd85bd0"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: "4900000000000",
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                )
            ],
            outputsData: [
                "0x",
                "0x"
            ],
            witnesses: [
                Witness(data: [])
            ]
        )
        XCTAssertEqual(tx.computeHash(), "0xc932addf21edeac2fdd4d677f3984688ee5514c87412087c6bb533bf96e4e624")
        // let hash = try? APIClient(url: APIClient.defaultLocalURL).computeTransactionHash(transaction: tx)
        // XCTAssertEqual(tx.computeHash(), hash)
    }

    func testTransactionWithInputs() {
        let tx = Transaction(
            cellDeps: [CellDep(outPoint: OutPoint(txHash: "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141", index: "0"), depType: .code)],
            headerDeps: ["0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e"],
            inputs: [CellInput(previousOutput: OutPoint(txHash: "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17", index: "0"), since: "0")],
            outputs: [CellOutput(capacity: "100000000000", lock: Script(args: [], codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data))],
            outputsData: ["0x"]
        )
        XCTAssertEqual(tx.computeHash(), "0xba86cc2cb21832bf4a84c032eb6e8dc422385cc8f8efb84eb0bc5fe0b0b9aece")
        // let hash = try? APIClient(url: APIClient.defaultLocalURL).computeTransactionHash(transaction: tx)
        // XCTAssertEqual(tx.computeHash(), hash)
    }
}
