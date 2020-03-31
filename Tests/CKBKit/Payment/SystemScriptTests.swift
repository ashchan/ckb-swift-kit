//
//  SystemScriptTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
import CKBFoundation
@testable import CKBKit

class SystemScriptTests: XCTestCase {
    /*
    func testLoadSystemScript() throws {
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: APIClient.defaultLocalURL)
        XCTAssertNotNil(systemScript)
        XCTAssertEqual("0x9bd7e06f3ecf4be0f2fcd2188b23f1b9fcc88e5d4b65a8637b17723bbda3cce8", systemScript.secp256k1TypeHash)
    }

    func testPublicKeyToScript() throws {
        let privateKey = Data(hex: "0xe79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let publicKey = Utils.privateToPublic(privateKey)
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: APIClient.defaultLocalURL)
        let lockScript = systemScript.lock(for: publicKey)
        let lockHash = lockScript.hash
        XCTAssertEqual("0x1f2615a8dde4e28ca736ff763c2078aff990043f4cbf09eb4b3a58a140a0862d", lockHash)
    }

    func testPublicKeyHashToScript() throws {
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: APIClient.defaultLocalURL)
        let publicKeyHash = "0x36c329ed630d6ce750712a477543672adab57f4c"
        let lockScript = systemScript.lock(for: publicKeyHash)
        let lockHash = lockScript.hash
        XCTAssertEqual("0x1f2615a8dde4e28ca736ff763c2078aff990043f4cbf09eb4b3a58a140a0862d", lockHash)
    }*/
}
