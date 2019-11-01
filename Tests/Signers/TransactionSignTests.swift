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
                    lock: Script(args: "0xe2193df51d78411601796b35b17b4f8f2cd85bd0", codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08", hashType: .data),
                    type: nil
                ),
                CellOutput(
                    capacity: 4900000000000,
                    lock: Script(args: "0x36c329ed630d6ce750712a477543672adab57f4c", codeHash: "0x9e3b3557f11b2b3532ce352bfe8017e9fd11d154c4c7f9b7aaaa1e621b539a08", hashType: .data),
                    type: nil
                )
            ],
            outputsData: [
                "0x",
                "0x"
            ],
            unsignedWitnesses: [
                WitnessArgs.emptyLock
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(
            signed.witnesses,
            [
                "0x55000000100000005500000055000000410000007a360306c20f1f0081d27feff5c59fb9b4307b25876543848010614fb78ea21d165f48f67ae3357eeafbad2033b1e53cd737d4e670de60e1081d514b1e05cf5100"
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
                    lock: Script(args: "0x36c329ed630d6ce750712a477543672adab57f4c", codeHash: "0xf1951123466e4479842387a66fabfd6b65fc87fd84ae8e6cd3053edb27fff2fd", hashType: .data),
                    type: nil
                )
            ],
            outputsData: [
                "0x"
            ],
            unsignedWitnesses: [
                .parsed("0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb", "0x", "0x"),
                .data("0x")
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses,
            [
                "0x55000000100000005500000055000000410000002dd0a2ee5c7e92af78d0fbbbf7ac6dab7e52602a33b9f189a87d2d0bd346443c5dec66a5c13434fcf55cebfc56c98254146fd189c1e7c6774e2b1a66519e6a4e00",
                "0x"
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
