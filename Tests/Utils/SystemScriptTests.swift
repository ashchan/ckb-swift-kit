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
        XCTAssertEqual("0x68d5438ac952d2f584abf879527946a537e82c7f3c1cbf6d8ebf9767437d8e88", systemScript.cellTypeHash)
    }
}
