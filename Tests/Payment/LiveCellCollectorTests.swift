//
//  LiveCellCollectorTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class LiveCellCollectorTests: RPCTestSkippable {
    func testGetUnspentCells() {
        let api = APIClient(url: APIClient.defaultLocalURL)
        let collector = LiveCellCollector(apiClient: api, publicKey: Data(hex: "0x03c4b0a0307375feac6970a994bf0b1d527c094aed271a86b085861f41fbbdb736"))
        let results = collector.getUnspentCells()
        XCTAssert(results.count >= 0)
    }
}
