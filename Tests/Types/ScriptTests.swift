//
//  ScriptTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/26.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class ScriptTests: XCTestCase {
    // Skipped
    func x_testTypeHashAlwaysSuccessCell() throws {
        let client = APIClient()
        let script = Script(
            version: 0,
            binary: nil,
            reference: try client.alwaysSuccessCellHash(),
            signedArgs: [],
            args: []
        )
        XCTAssertEqual("0x0da2fe99fe549e082d4ed483c2e968a89ea8d11aabf5d79e5cbf06522de6e674", script.typeHash)
    }

    func testTypeHash() throws {
        let script = Script(
            version: 0,
            binary: nil,
            reference: nil,
            signedArgs: [],
            args: []
        )
        XCTAssertEqual("0xfabf6ebecf2a3fca37f42d27298ca2af064acfa050b0454dab6da29d1a121f69", script.typeHash)
    }
}
