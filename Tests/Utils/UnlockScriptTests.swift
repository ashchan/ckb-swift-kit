//
//  UnlockScriptTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/19.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class UnlockScriptTests: XCTestCase {
    func testLoadScript() {
        let script = VerifyScript.script
        XCTAssertFalse(script.content.isEmpty)
    }
}
