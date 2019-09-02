//
//  SystemScriptTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class SystemScriptTests: RPCTestSkippable {
    func testLoadSystemScript() throws {
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: APIClient.defaultLocalURL)
        XCTAssertNotNil(systemScript)
        XCTAssertEqual("0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88", systemScript.secp256k1TypeHash)
    }

    func x_testPublicKeyToScript() throws {
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let publicKey = Utils.privateToPublic(privateKey)
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: APIClient.defaultLocalURL)
        let lockScript = systemScript.lock(for: publicKey.toHexString())
        XCTAssertEqual("0x024b0fd0c4912e98aab6808f6474cacb1969255d526b3cac5d3bdd15962a8818", lockScript.hash)
    }
}
