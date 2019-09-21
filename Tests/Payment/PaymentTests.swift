//
//  PaymentTests.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import XCTest
@testable import CKB

class PaymentConstructionTests: XCTestCase {
    let apiClient = APIClient(url: APIClient.defaultLocalURL)

    func testInvalidFromAddress() {
        XCTAssertThrowsError(
            try Payment(
                from: "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323i", // Invalid checksum
                to: "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
                amount: Payment.minAmount + 100  * 100_000_000,
                apiClient: apiClient
            )
        ) {
            XCTAssertEqual($0.localizedDescription, Payment.Error.invalidFromAddress.localizedDescription)
        }
    }

    func testInvalidToAddress() {
        XCTAssertThrowsError(
            try Payment(
                from: "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
                to: "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323i", // Invalid checksum
                amount: Payment.minAmount + 100  * 100_000_000,
                apiClient: apiClient
            )
        ) {
            XCTAssertEqual($0.localizedDescription, Payment.Error.invalidToAddress.localizedDescription)
        }
    }

    func testInsufficientAmount() {
        XCTAssertThrowsError(
            try Payment(
                from: "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
                to: "ckb1qyqp8eqad7ffy42ezmchkjyz54rhcqf8q9pqrn323p",
                amount: Payment.minAmount - Capacity(1),
                apiClient: apiClient
            )
        ) {
            XCTAssertEqual($0.localizedDescription, Payment.Error.insufficientAmount.localizedDescription)
        }
    }
}

class PaymentTests: RPCTestSkippable {
    let apiClient = APIClient(url: APIClient.defaultLocalURL)
    let privateKey = Data(hex: "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
    let fromAddress = "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83"

    func testPrivateKeyNotMatchFromAddress() {
        let payment = try! Payment(
            from: "ckt1qyq0phsyqvgkfkzrshphsramyxyz8yew3yzsl76naf",
            to: "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            amount: Payment.minAmount + 100  * 100_000_000,
            apiClient: apiClient
        )
        payment.unspentCellCollectorType = FakeCellCollector.self

        XCTAssertThrowsError(try payment.sign(privateKey: privateKey)) {
            XCTAssertEqual($0.localizedDescription, Payment.Error.privateKeyAndAddressNotMatch.localizedDescription)
        }
    }

    func testInsufficientBalance() {
        let payment = try! Payment(
            from: fromAddress,
            to: "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            amount: 20_000  * 100_000_000,
            apiClient: apiClient
        )
        payment.unspentCellCollectorType = FakeCellCollector.self

        XCTAssertThrowsError(try payment.sign(privateKey: privateKey)) {
            XCTAssertEqual($0.localizedDescription, Payment.Error.insufficientBalance.localizedDescription)
        }
    }

    func testRequireSignBeforeSend() {
        let payment = try! Payment(
            from: fromAddress,
            to: "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            amount: 20_000  * 100_000_000,
            apiClient: apiClient
        )
        payment.unspentCellCollectorType = FakeCellCollector.self

        XCTAssertThrowsError(try payment.send()) {
            XCTAssertEqual($0.localizedDescription, Payment.Error.txNotSigned.localizedDescription)
        }
    }

    func testSignPayment() {
        let payment = try! Payment(
            from: fromAddress,
            to: "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
            amount: 5_000  * 100_000_000,
            apiClient: apiClient
        )
        payment.unspentCellCollectorType = FakeCellCollector.self

        XCTAssertNoThrow(try payment.sign(privateKey: privateKey))
    }

    // Do not run. Require tokens from sender.
    func x_testSignAndSendPayment() {
        let payment = try! Payment(
            from: fromAddress,
            to: "ckt1qyqy0frc0r8kus23ermqkxny662m37yc26fqpcyqky",
            amount: 100  * 100_000_000,
            apiClient: apiClient
        )

        XCTAssertNoThrow(try payment.sign(privateKey: privateKey))
        let txhash = try? payment.send()
        XCTAssertNotNil(txhash)
    }

    // MARK: - Fake collector for test only

    final class FakeCellCollector: UnspentCellCollector {
        private let apiClient: APIClient
        let publicKeyHash: Data

        lazy var lock: Script = {
            let systemScript = try! SystemScript.loadSystemScript(apiClient: apiClient)
            return systemScript.lock(for: publicKeyHash.toHexString())
        }()

        var lockHash: String {
            return lock.computeHash()
        }

        init(apiClient: APIClient, publicKeyHash: Data) {
            self.apiClient = apiClient
            self.publicKeyHash = publicKeyHash
        }

        // Always return cells for 10,000 CKB
        func getUnspentCells(from blockNumber: BlockNumber, maxCapacity: Capacity) -> [CellOutputWithOutPoint] {
            let makeCell: (_ capacity: Capacity) -> CellOutputWithOutPoint = { [unowned self] capacity in
                return CellOutputWithOutPoint(
                    outPoint: OutPoint(txHash: H256.zeroHash, index: 0),
                    blockHash: H256.zeroHash,
                    capacity: capacity,
                    lock: Script(args: [Utils.prefixHex(self.publicKeyHash.toHexString())], codeHash: H256.zeroHash, hashType: .type)
                )
            }
            return [
                makeCell(1000_00_000_000),
                makeCell(2000_00_000_000),
                makeCell(3000_00_000_000),
                makeCell(4000_00_000_000)
            ]
        }
    }
}
