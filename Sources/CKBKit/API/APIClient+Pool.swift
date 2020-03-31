//
//  APIClient+Pool.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import CKBFoundation

public extension APIClient {
    func sendTransaction(transaction: Transaction) throws -> H256 {
        return try load(APIRequest<H256>(method: "send_transaction", params: [transaction.param]))
    }

    func txPoolInfo() throws -> TxPoolInfo {
        return try load(APIRequest<TxPoolInfo>(method: "tx_pool_info", params: []))
    }
}
