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
                "0x0"
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses,
            [
                "0x351e10e4dca1076cc87244cfc7565c1fa83b6fa693b6c5ce41ad0d7269bf7d855f8d34d5d195edf2d45f4f6d02085843595b6d96de265dbd237a8828eda879b2010"
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
                "0x0"
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
            "0xb1cd85ec56d1149b7ad3ca875159b3148e9dff8c1b316a6a277439a838fcb4540e64910b0dcd9ef7ac90e58a80143798b69251a644016bb5096d18f8bf1ca2a2010"
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
