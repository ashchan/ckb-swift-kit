//
//  TransactionSignTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class TransactionSignTests: XCTestCase {
    func testSign() throws {
        let tx = Transaction(
            version: 0,
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xa76801d09a0eabbfa545f1577084b6f3bafb0b6250e7f5c89efcfd4e3499fb55", index: 1), depType: .code)
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(txHash: "0xa80a8e01d45b10e1cbc8a2557c62ba40edbdc36cd63a31fc717006ca7b157b50", index: 0),
                    since: 0
                )
            ],
            outputs: [
                CellOutput(
                    capacity: 100000000000,
                    lock: Script(args: "0xe2193df51d78411601796b35b17b4f8f2cd85bd0", codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: 4900000000000,
                    lock: Script(args: "0x36c329ed630d6ce750712a477543672adab57f4c", codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                )
            ],
            outputsData: [
                "0x",
                "0x"
            ],
            witnesses: [
                "0x"
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses,
            [
                "0x15edb4da91bd5beebf0aee82a9daa4d590ecdfc0895c6b010638573b2d1d502c50373e7d540e74eb8e3a3bd1dbd20c372c492fc7242592c8a04763be029325a900"
            ]
        )
    }

    func testMultipleInputsSign() throws {
        let tx = Transaction(
            version: 0,
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xa76801d09a0eabbfa545f1577084b6f3bafb0b6250e7f5c89efcfd4e3499fb55", index: 1), depType: .code)
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(txHash: "0x91fcfd61f420c1090aeded6b6d91d5920a279fe53ec34353afccc59264eeddd4", index: 0),
                    since: 113
                ),
                CellInput(
                    previousOutput: OutPoint(txHash: "0x00000000000000000000000000004e4552564f5344414f494e50555430303031", index: 0),
                    since: 0
                )
            ],
            outputs: [
                CellOutput(
                    capacity: 10000009045634,
                    lock: Script(args: "0x36c329ed630d6ce750712a477543672adab57f4c", codeHash: "0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd"),
                    type: nil
                )
            ],
            outputsData: [
                "0x"
            ],
            witnesses: [
                "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb",
                "0x"
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses.first,
            "0x2db8278bf806fb7eac778e56eb0b34deccb16bae68c2a088d277bded265d90da37fb995a1f629a9de7c9722640f2f9c67c5572e6b5fca1e831649484ba9a0b81004107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"
        )
        XCTAssertEqual(
            signed.witnesses[1],
            "0x014de9c721a5a33435a02d44580978ecdb794d2a7f3fe7d875e7f058ef8c961f2e983079400cfd8a2bbe34f2d1fd3f0a6e2c390bf7e45006c06c7831e4a67e8101"
        )
    }

    func testThrowErrorWhenWitnessesUnsatisfied() {
        let tx = Transaction(
            version: 0,
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xa76801d09a0eabbfa545f1577084b6f3bafb0b6250e7f5c89efcfd4e3499fb55", index: 1), depType: .code)
            ],
            inputs: [
                CellInput(
                    previousOutput: OutPoint(txHash: "0xa80a8e01d45b10e1cbc8a2557c62ba40edbdc36cd63a31fc717006ca7b157b50", index: 0),
                    since: 0
                )
            ],
            outputs: [
                CellOutput(
                    capacity: 100000000000,
                    lock: Script(args: "0xe2193df51d78411601796b35b17b4f8f2cd85bd0", codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: 4900000000000,
                    lock: Script(args: "0x36c329ed630d6ce750712a477543672adab57f4c", codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                )
            ],
            outputsData: [
                "0x",
                "0x"
            ],
            witnesses: []
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        XCTAssertThrowsError(try Transaction.sign(tx: tx, with: privateKey)) { error in
            XCTAssertEqual(error.localizedDescription, Transaction.Error.invalidNumberOfWitnesses.localizedDescription)
        }
    }
}
