//
//  Bech32Tests.swift
//  CKBTests
//
//  Created by James Chen on 2019/04/15.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class Bech32Tests: XCTestCase {
    func testEncode() {
        let data = Data([0x00]) + "P2PH".data(using: .ascii)! + Data(hex: "0x13e41d6F9292555916f17B4882a5477C01270142")
        XCTAssertEqual(
            "ckb1qpgry5zgz0jp6mujjf24j9h30dyg9f280sqjwq2zfudqzw",
            Bech32().encode(hrp: "ckb", data: data)
        )
    }

    func testDecode() {
        let data = Data([0x00]) + "P2PH".data(using: .ascii)! + Data(hex: "0x13e41d6F9292555916f17B4882a5477C01270142")
        let decoded = Bech32().decode(bech32: "ckb1qpgry5zgz0jp6mujjf24j9h30dyg9f280sqjwq2zfudqzw")!
        XCTAssertEqual("ckb", decoded.hrp)
        XCTAssertEqual(data, decoded.data)
    }

    func testValidChecksums() {
        let validChecksums = [
            "A12UEL5L",
            "an83characterlonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1tt5tgs",
            "abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw",
            "11qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqc8247j",
            "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w"
        ]
        validChecksums.forEach { (address) in
            let decoded = Bech32().decode(bech32: address)
            XCTAssertNotNil(decoded, address)
        }
    }

    func testInvalidChecksums() {
        let invalidChecksums = [
            " 1nwldj5",
            "\0x7F1axkwrx",
            "an84characterslonghumanreadablepartthatcontainsthenumber1andtheexcludedcharactersbio1569pvx",
            "pzry9x0s0muk",
            "1pzry9x0s0muk",
            "x1b4n0q5v",
            "li1dgmt3",
            "de1lg7wt\0xff"
        ]
        invalidChecksums.forEach { (address) in
            let decoded = Bech32().decode(bech32: address)
            XCTAssertNil(decoded, address)
        }
    }
}
