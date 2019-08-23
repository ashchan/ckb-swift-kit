//
//  APIClient+Experiment.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    func computeTransactionHash(transaction: Transaction) throws -> H256 {
        return try load(APIRequest<H256>(method: "_compute_transaction_hash", params: [transaction.param]))
    }

    func computeScriptHash(script: Script) throws -> H256 {
        return try load(APIRequest<H256>(method: "_compute_script_hash", params: [script.param]))
    }

    func dryRunTransaction(transaction: Transaction) throws -> DryRunResult {
        return try load(APIRequest<DryRunResult>(method: "dry_run_transaction", params: [transaction.param]))
    }
}
