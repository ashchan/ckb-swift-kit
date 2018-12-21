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
    func testPrivateToPublic() {
        let privateKey = "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3"
        let publicKey = "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01"
        XCTAssertEqual(publicKey, Utils.privateToPublic(privateKey))
    }

    func testPrivateToAddress() {
        let privateKey = "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3"
        let address = "0x6c5b2cd24ce7cbc16ff368d116294b3c8e5e4f33197900396e9a35d52d8c0f83"
        XCTAssertEqual(address, Utils.privateToAddress(privateKey))
    }
}
