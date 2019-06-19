//
//  APIClient+Pool.swift
//  CKB
//
//  Created by James Chen on 2019/06/19.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    func sendTransaction(transaction: Transaction) throws -> H256 {
        return try load(APIRequest<H256>(method: "send_transaction", params: [transaction.param]))
    }

    func txPoolInfo() throws -> TxPoolInfo {
        return try load(APIRequest<TxPoolInfo>(method: "tx_pool_info", params: []))
    }
}
