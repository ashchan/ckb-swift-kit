//
//  ScriptTests.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
import CKBFoundation
@testable import CKBKit

class ScriptTests: XCTestCase {
    func testCodeHashHasPrefix() {
        let codeHash = Utils.prefixHex(H256.zeroHash)
        let script = Script(codeHash: H256(codeHash.dropFirst(2)))
        XCTAssertEqual(codeHash, script.codeHash)
        XCTAssertEqual(codeHash, script.param["code_hash"] as! H256)
    }
}
