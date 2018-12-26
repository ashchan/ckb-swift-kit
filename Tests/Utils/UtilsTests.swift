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
        let address = "0xc35e6ddf1140e7feaef6431bb182d11071f4bfb5e68d05b7ad0a95cbfccb4a66"
        XCTAssertEqual(address, Utils.privateToAddress(privateKey))
    }

    func testTypeHash() throws {
        let client = APIClient()
        let script = Script(
            version: 0,
            binary: nil,
            reference: try client.alwaysSuccessCellHash(),
            signedArgs: [],
            args: []
        )
        let result = Utils.typeHash(from: script)
        XCTAssertEqual("0x0da2fe99fe549e082d4ed483c2e968a89ea8d11aabf5d79e5cbf06522de6e674", result)
    }
}
