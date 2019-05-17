//
//  ViewController.swift
//  Example-iOS
//
//  Created by James Chen on 2019/04/28.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import UIKit
import CKB

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            try testNodeInfo()
            try testSendCapacity()
        } catch let err {
            print(err.localizedDescription)
        }
    }
}

extension ViewController {
    func testNodeInfo() throws {
        let nodeUrl = URL(string: "http://localhost:8114")!
        let apiClient = APIClient(url: nodeUrl)

        // Fetch local node info
        let nodeInfo = try apiClient.localNodeInfo()
        print(nodeInfo.version)                        // "0.12.0-pre (rylai30-1-g3e765560 2019-05-16)"

        // Get current height
        let height = try apiClient.getTipBlockNumber() // Numbers are represented as strings
        print(height)
    }

    func testSendCapacity() throws {
        // Fetch system script which we'll use to generate lock for address
        let nodeUrl = URL(string: "http://localhost:8114")!
        let systemScript = try SystemScript.loadFromGenesisBlock(nodeUrl: nodeUrl)
        // Fill in the sender's private key
        let privateKey: Data = Data(hex: "your private key (hex string)")

        // Push system script's out point into deps
        let deps = [systemScript.outPoint]

        // Gather inputs. For an simple example of how to gather inputs, see our Testnet Faucet's [wallet module](https://github.com/nervosnetwork/ckb-testnet-faucet/blob/develop/faucet-server/Sources/App/Services/Wallet/Wallet.swift#L60).
        let inputs: [CellInput] = [/*...*/]

        // Generate lock script for the receiver's address
        let toAddress = "ckt1q9gry5zgw2q74lpmm03tw9snpqph2myqkkpyfss95qs228"
        let addressHash = Utils.prefixHex(AddressGenerator(network: .testnet).publicKeyHash(for: toAddress)!) // "0x7281eafc3bdbe2b716130803756c80b58244c205"
        let lockScript = Script(args: [addressHash], codeHash: systemScript.codeHash)
        // Construct the outputs
        let outputs = [CellOutput(capacity: 500_00_000_000.description, data: "0x", lock: lockScript, type: nil)]

        // Generate the transaction
        let tx = Transaction(deps: deps, inputs: inputs, outputs: outputs)
        // For now we need to call the `computeTransactionHash` to get the tx hash
        let apiClient = APIClient(url: nodeUrl)
        let txHash = try apiClient.computeTransactionHash(transaction: tx)
        let signedTx = Transaction.sign(tx: tx, with: privateKey, txHash: txHash)

        // Now send out the capacity
        let hash = try apiClient.sendTransaction(transaction: signedTx)
        print(hash) // hash should equal to txHash
    }
}
