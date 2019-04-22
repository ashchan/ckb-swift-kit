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
        let data: [UInt8] = [0, 14, 20, 15, 7, 13, 26, 0, 25, 18, 6, 11, 13, 8, 21, 4, 20, 3, 17, 2, 29, 3, 12, 29, 3, 4, 15, 24, 20, 6, 14, 30, 22]
        XCTAssertEqual(
            "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4",
            Bech32().encode(hrp: "bc", data: Data(data))
        )
    }

    func testDecode() {
        let bytes: [UInt8] = [0, 14, 20, 15, 7, 13, 26, 0, 25, 18, 6, 11, 13, 8, 21, 4, 20, 3, 17, 2, 29, 3, 12, 29, 3, 4, 15, 24, 20, 6, 14, 30, 22]
        let decoded = Bech32().decode(bech32: "bc1qw508d6qejxtdg4y5r3zarvary0c5xw7kv8f3t4")!
        XCTAssertEqual("bc", decoded.hrp)
        XCTAssertEqual(Data(bytes), decoded.data)
    }

    func testDecodeValidAddresses() {
        let validAddresses = [
            "BC1QW508D6QEJXTDG4Y5R3ZARVARY0C5XW7KV8F3T4",
            "tb1qrp33g0q5c5txsp9arysrx4k6zdkfs4nce4xj0gdcccefvpysxf3q0sl5k7",
            "bc1pw508d6qejxtdg4y5r3zarvary0c5xw7kw508d6qejxtdg4y5r3zarvary0c5xw7k7grplx",
            "BC1SW50QA3JX3S",
            "bc1zw508d6qejxtdg4y5r3zarvaryvg6kdaj",
            "tb1qqqqqp399et2xygdj5xreqhjjvcmzhxw4aywxecjdzew6hylgvsesrxh6hy"
        ]
        validAddresses.forEach { (address) in
            let decoded = Bech32().decode(bech32: address)
            XCTAssertNotNil(decoded)
        }
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
