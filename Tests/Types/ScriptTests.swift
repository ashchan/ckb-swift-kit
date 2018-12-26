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
    func testTypeHash() throws {
        let client = APIClient()
        let script = Script(
            version: 0,
            binary: nil,
            reference: try client.alwaysSuccessCellHash(),
            signedArgs: [],
            args: []
        )
        let result = script.typeHash
        XCTAssertEqual("0x0da2fe99fe549e082d4ed483c2e968a89ea8d11aabf5d79e5cbf06522de6e674", result)
    }
}
