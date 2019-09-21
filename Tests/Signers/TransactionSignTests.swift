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
                    lock: Script(args: ["0xe2193df51d78411601796b35b17b4f8f2cd85bd0"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: 4900000000000,
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
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses.first!.data,
            [
                "0x13eb78ef3ed0f40a13df2e4c872875cf69d326fe4c7f1a022078e0e9768d403510b2e202cf504edad6215abb7861ce126458d650355f4dbedac9ee0aeff8097800"
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
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd"),
                    type: nil
                )
            ],
            outputsData: [
                "0x"
            ],
            witnesses: [
                Witness(data: ["0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"]),
                Witness(data: [])
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses.first!.data,
            [
                "0x1c6b872ac9f28a777fd3006e8007302c8686334c63441364c1a38a06bf0400e206747847e4e002ebc3eaffa8a6ca88d513a745720eec501dd723051a457a208601",
                "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"
            ]
        )
        XCTAssertEqual(
            signed.witnesses[1].data,
            [
                "0xba231bed5fda5eb8a7c142b28ff0fe6cef9fdef3b8d60ea0d80e65ea60010acf0254a9c50d6b3caaf2aee9274e191b7758e9ded09faac9c19ce16d8da150e54b01"
            ]
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
                    lock: Script(args: ["0xe2193df51d78411601796b35b17b4f8f2cd85bd0"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
                    type: nil
                ),
                CellOutput(
                    capacity: 4900000000000,
                    lock: Script(args: ["0x36c329ed630d6ce750712a477543672adab57f4c"], codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08"),
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
