//
//  UtilsTests.swift
//  CKBTests
//
//  Created by James Chen on 2018/12/17.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class UtilsTests: XCTestCase {
    func testPrivateToAddress() {
        let privateKey = "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3"
        let address = Utils.privateToAddress(privateKey)
        XCTAssertEqual("0x565cd9ac9a251109ff642090b91af29bfaa451b2d0e3093a29bba74743408a4a", address)
    }
}
