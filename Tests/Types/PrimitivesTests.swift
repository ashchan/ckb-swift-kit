//
//  PrimitivesTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKBKit

class PrimitivesTests: XCTestCase {
    func testUnsignedIntegerHexInitializer() {
        XCTAssertEqual(0, UInt8(hexString: "0"))
        XCTAssertEqual(0, UInt8(hexString: "0x0"))
        XCTAssertEqual(UInt8.max, UInt8(hexString: "0xff"))
        XCTAssertNil(UInt8(hexString: "0xfg"))
        XCTAssertNil(UInt8(hexString: "0xff1"))

        XCTAssertEqual(0, UInt16(hexString: "0"))
        XCTAssertEqual(0, UInt16(hexString: "0x0"))
        XCTAssertEqual(UInt16.max, UInt16(hexString: "0xffff"))
        XCTAssertNil(UInt8(hexString: "0xfffg"))
        XCTAssertNil(UInt8(hexString: "0xffff1"))

        XCTAssertEqual(0, UInt32(hexString: "0"))
        XCTAssertEqual(0, UInt32(hexString: "0x0"))
        XCTAssertEqual(UInt32.max, UInt32(hexString: "0xffffffff"))
        XCTAssertNil(UInt32(hexString: "0xfffffffg"))
        XCTAssertNil(UInt32(hexString: "0xffffffff1"))

        XCTAssertEqual(0, UInt64(hexString: "0"))
        XCTAssertEqual(0, UInt64(hexString: "0x0"))
        XCTAssertEqual(UInt64.max, UInt64(hexString: "0xffffffffffffffff"))
        XCTAssertNil(UInt64(hexString: "0xfffffffffffffffg"))
        XCTAssertNil(UInt64(hexString: "0xffffffffffffffff1"))
    }

    func testUnsignedIntegerToHexString() {
        XCTAssertEqual("0x0", UInt8(0).hexString)
        XCTAssertEqual("0xff", UInt8.max.hexString)

        XCTAssertEqual("0x0", UInt16(0).hexString)
        XCTAssertEqual("0xffff", UInt16.max.hexString)

        XCTAssertEqual("0x0", UInt32(0).hexString)
        XCTAssertEqual("0xffffffff", UInt32.max.hexString)

        XCTAssertEqual("0x0", UInt64(0).hexString)
        XCTAssertEqual("0xffffffffffffffff", UInt64.max.hexString)

        XCTAssertEqual("0x400", UInt32(1024).hexString)
        XCTAssertEqual("0xabcdef", UInt32(11259375).hexString)
    }

    func testDateFromTimestamp() {
        let timestamp = UInt64(1567836000183).hexString
        let date = Date(hexSince1970: timestamp)
        let d20190907 = Calendar.current.dateComponents([.year, .month, .day], from: date)
        XCTAssertEqual(2019, d20190907.year)
        XCTAssertEqual(9, d20190907.month)
        XCTAssertEqual(7, d20190907.day)
    }
}
