//
//  TransactionSerializerTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBFoundation

class TransactionSerializerTests: XCTestCase {
    func testTransaction() {
        let tx = Transaction(
            version: 0,
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xbffab7ee0a050e2cb882de066d3dbf3afdd8932d6a26eda44f06e4b23f0f4b5a", index: 0), depType: .code)
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
        XCTAssertEqual(tx.computeHash(), "0x4c02905db773301f73bbc6cd5a400c928caf410bbb13136f6f48bec0a79c22e4")
        // let hash = try? APIClient(url: APIClient.defaultLocalURL).computeTransactionHash(transaction: tx)
        // XCTAssertEqual(tx.computeHash(), hash)
    }

    func testTransactionWithInputs() {
        let tx = Transaction(
            cellDeps: [CellDep(outPoint: OutPoint(txHash: "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141", index: 0), depType: .code)],
            headerDeps: ["0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e"],
            inputs: [CellInput(previousOutput: OutPoint(txHash: "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17", index: 0), since: 0)],
            outputs: [CellOutput(capacity: 100000000000, lock: Script(args: "0x", codeHash: "0x28e83a1277d48add8e72fadaa9248559e1b632bab2bd60b27955ebc4c03800a5", hashType: .data))],
            outputsData: ["0x"]
        )
        XCTAssertEqual(tx.computeHash(), "0x6f6b16079884d8127490aac5e0f87274e81f15ea1fd6c9672a5b0326bd8ce76d")
        // let hash = try? APIClient(url: APIClient.defaultLocalURL).computeTransactionHash(transaction: tx)
        // XCTAssertEqual(tx.computeHash(), hash)
    }

    func testTransactionWithWitnesses() {
        let tx = Transaction(
            cellDeps: [CellDep(outPoint: OutPoint(txHash: "0x29f94532fb6c7a17f13bcde5adb6e2921776ee6f357adf645e5393bd13442141", index: 0), depType: .code)],
            headerDeps: ["0x8033e126475d197f2366bbc2f30b907d15af85c9d9533253c6f0787dcbbb509e"],
            inputs: [
                CellInput(previousOutput: OutPoint(txHash: "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17", index: 0), since: 0),
                CellInput(previousOutput: OutPoint(txHash: "0x5ba156200c6310bf140fbbd3bfe7e8f03d4d5f82b612c1a8ec2501826eaabc17", index: 0), since: 1)
            ],
            outputs: [],
            outputsData: ["0x"],
            witnesses: [
                "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb",
                "0x4107bd23eedb9f2a2a749108f6bb9720d745d50f044cc4814bafe189a01fe6fb"
            ]
        )
        XCTAssertEqual(tx.computeHash(), "0xe37f68d4d81e0f790ca98c5abbd763764f826170867a0b96137f68df908e5641")
    }

    func testSerializedSizeInBlock() {
        let tx = Transaction(
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xc12386705b5cbb312b693874f3edf45c43a274482e27b8df0fd80c8d3f5feb8b", index: 0), depType: .depGroup),
                CellDep(outPoint: OutPoint(txHash: "0x0fb4945d52baf91e0dee2a686cdd9d84cad95b566a1d7409b970ee0a0f364f60", index: 2), depType: .depGroup)
            ],
            headerDeps: [],
            inputs: [
                CellInput(previousOutput: OutPoint(txHash: "0x31f695263423a4b05045dd25ce6692bb55d7bba2965d8be16b036e138e72cc65", index: 1), since: 0)
            ],
            outputs: [
                CellOutput(
                    capacity: 100_000_000_000,
                    lock: Script(args: "0x59a27ef3ba84f061517d13f42cf44ed020610061", codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88", hashType: .type),
                    type: Script(args: "0x", codeHash: "0xece45e0979030e2f8909f76258631c42333b1e906fd9701ec3600a464a90b8f6", hashType: .data)
                ),
                CellOutput(capacity: 98_824_000_000_000, lock: Script(args: "0x59a27ef3ba84f061517d13f42cf44ed020610061", codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88", hashType: .type)),
            ],
            outputsData: ["0x1234", "0x"],
            witnesses: [
                "0x82df73581bcd08cb9aa270128d15e79996229ce8ea9e4f985b49fbf36762c5c37936caf3ea3784ee326f60b8992924fcf496f9503c907982525a3436f01ab32900",
            ]
        )
        XCTAssertEqual(tx.serializedSizeInBlock, 536)
    }

    func testFeeForSizeAndRate() {
        XCTAssertEqual(932, Transaction.fee(for: 1035, with: 900))
        XCTAssertEqual(1035, Transaction.fee(for: 1035, with: 1000))
        XCTAssertEqual(1041, Transaction.fee(for: 1038, with: 1002))
    }

    func testTransactionFee() {
        let tx = Transaction(
            cellDeps: [
                CellDep(outPoint: OutPoint(txHash: "0xc12386705b5cbb312b693874f3edf45c43a274482e27b8df0fd80c8d3f5feb8b", index: 0), depType: .depGroup),
                CellDep(outPoint: OutPoint(txHash: "0x0fb4945d52baf91e0dee2a686cdd9d84cad95b566a1d7409b970ee0a0f364f60", index: 2), depType: .depGroup)
            ],
            headerDeps: [],
            inputs: [
                CellInput(previousOutput: OutPoint(txHash: "0x31f695263423a4b05045dd25ce6692bb55d7bba2965d8be16b036e138e72cc65", index: 1), since: 0)
            ],
            outputs: [
                CellOutput(
                    capacity: 100_000_000_000,
                    lock: Script(args: "0x59a27ef3ba84f061517d13f42cf44ed020610061", codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88", hashType: .type),
                    type: Script(args: "0x", codeHash: "0xece45e0979030e2f8909f76258631c42333b1e906fd9701ec3600a464a90b8f6", hashType: .data)
                ),
                CellOutput(capacity: 98_824_000_000_000, lock: Script(args: "0x59a27ef3ba84f061517d13f42cf44ed020610061", codeHash: "0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88", hashType: .type)),
            ],
            outputsData: ["0x1234", "0x"],
            witnesses: [
                "0x82df73581bcd08cb9aa270128d15e79996229ce8ea9e4f985b49fbf36762c5c37936caf3ea3784ee326f60b8992924fcf496f9503c907982525a3436f01ab32900",
            ]
        )
        XCTAssertEqual(536, tx.fee(rate: 1000))
    }
}
