//
//  SystemScriptTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class SystemScriptTests: RPCTestSkippable {
    func testLoadFromGenesisBlock() {
        let systemScript = try? SystemScript.loadFromGenesisBlock(nodeUrl: APIClient.defaultLocalURL)
        XCTAssertNotNil(systemScript)
    }
}
