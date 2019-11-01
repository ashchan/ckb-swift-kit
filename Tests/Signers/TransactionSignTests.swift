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
                .parsed("0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb", "0x99caa8d7efdaab11c2bb7e45f4f385d0405f0fa2e8d3ba48496c28a2443e607d", "0xa6d5e23a77f4d7940aeb88764eebf8146185138641ac43b233e1c9b3daa170fa"),
                .data("0x")
            ]
        )
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(signed.witnesses.count, tx.inputs.count)
        XCTAssertEqual(
            signed.witnesses,
            [
                "0x9d00000010000000550000007900000041000000d896d67ddda97ab2d15cd13098b40e4a2b6d6c66ad465d987df9a28b0a038f4a18dbebbc702a1a0b2056aa9e4290a3640a4d73dd1f6483e6f8e0cd2784b4a78b002000000099caa8d7efdaab11c2bb7e45f4f385d0405f0fa2e8d3ba48496c28a2443e607d20000000a6d5e23a77f4d7940aeb88764eebf8146185138641ac43b233e1c9b3daa170fa",
                "0x"
            ]
        )
    }

    func testMultipleInputSign2() throws {
       let tx = Transaction(
             version: 0,
             cellDeps: [
                 CellDep(outPoint: OutPoint(txHash: "0xe7d5ddd093bcc5909a6f441882e58906062eaf66a6ac1bcf7d7411931bc9ab72", index: 0), depType: .depGroup)
             ],
             inputs: [
                 CellInput(
                     previousOutput: OutPoint(txHash: "0xa31b9b8d105c62d69b7fbfc09bd700f3a1d6659232ffcfaa12a048ee5d7b7f2d", index: 0),
                     since: 0
                 ),
                 CellInput(
                     previousOutput: OutPoint(txHash: "0xec5e63e19ec0161092ba78a841e9ead5deb30e56c2d98752ed974f2f2b4aeff2", index: 0),
                     since: 0
                 ),
                 CellInput(
                     previousOutput: OutPoint(txHash: "0x5ad2600cb884572f9d8f568822c0447f6f49eb63b53257c20d0d8559276bf4e2", index: 0),
                     since: 0
                 ),
                 CellInput(
                     previousOutput: OutPoint(txHash: "0xf21e34224e90c1ab47f42e2977ea455445d22ba3aaeb4bd2fcb2075704f330ff", index: 0),
                     since: 0
                 ),
                 CellInput(
                     previousOutput: OutPoint(txHash: "0xc8212696d516c63bced000d3008c4a8c27c72c03f4becb40f0bf24a31063271f", index: 0),
                     since: 0
                 )
             ],
             outputs: [
                 CellOutput(
                     capacity: 1000000000000,
                     lock: Script(args: "0x59a27ef3ba84f061517d13f42cf44ed020610061", codeHash: "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8", hashType: .type),
                     type: nil
                 ),
                 CellOutput(
                     capacity: 19113828003,
                     lock: Script(args: "0x3954acece65096bfa81258983ddb83915fc56bd8", codeHash: "0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8", hashType: .type),
                     type: nil
                 )
             ],
             outputsData: [
                 "0x",
                 "0x"
             ],
             unsignedWitnesses: [
                WitnessArgs.parsed("0x", "0x", "0x"),
                WitnessArgs.data("0x"),
                WitnessArgs.data("0x"),
                WitnessArgs.data("0x"),
                WitnessArgs.data("0x")
             ]
         )
        let privateKey = Data(hex: "0x845b781a1a094057b972714a2b09b85de4fc2eb205351c3e5179aabd264f3805")
        XCTAssertEqual("0x03aea57404a99c685b098b7ee96469f0c5db57fa49aaef27cf7c080960da4b19", tx.computeHash())
        let signed = try Transaction.sign(tx: tx, with: privateKey)
        XCTAssertEqual(
            "0x550000001000000055000000550000004100000090cdaca0b898586ef68c02e8514087e620d3b19767137baf2fbc8dee28c83ac047be76c76d7f5098a759f3d417c1daedf534a3772aa29159d807d948ed1f8c3a00",
            signed.witnesses.first
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
