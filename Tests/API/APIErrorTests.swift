//
//  APIErrorTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class APIErrorTests: XCTestCase {
    func testLocalizedError() {
        func nullError() throws {
            throw APIError.nullResult
        }

        XCTAssertThrowsError(try nullError()) { error in
            XCTAssertEqual(error.localizedDescription, APIError.nullResult.localizedDescription)
        }
        XCTAssertEqual(
            APIError.nullResult.errorDescription,
            "Null result"
        )
    }

    func testGenericError() {
        let error = APIError.genericError("Shit happens")
        XCTAssertEqual(error.errorDescription, "Shit happens")
    }
}
