//
//  Secp256k1Tests.swift
//  CKBTests
//
//  Created by James Chen on 2019/03/02.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class Secp256k1Tests: XCTestCase {
    func testPrivateToPublic() {
        let privateKey = Data(hex: "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
        let publicKey = Data(hex: "024a501efd328e062c8675f2365970728c859c592beeefd6be8ead3d901330bc01")
        XCTAssertEqual(publicKey, Secp256k1.privateToPublic(privateKey: privateKey))
    }
}
