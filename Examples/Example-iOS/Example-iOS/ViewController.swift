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
    @IBOutlet weak var nodeUrlTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    var nodeUrl: URL {
        return URL(string: nodeUrlTextField.text!) ?? URL(string: "http://localhost:8114")!
    }
    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        infoTextView.layer.borderWidth = 1.0 / UIScreen.main.scale
        infoTextView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @IBAction func checkNodeInfo(_ sender: Any) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        timer!.fire()
    }

    @objc private func tick() {
        let node = nodeUrl
        DispatchQueue.global().async {
            self.getNodeInfo(node)
        }
    }

    private func showInfo(_ info: String) {
        DispatchQueue.main.async {
            self.infoTextView.text = info
            self.infoTextView.layer.borderColor = UIColor.green.cgColor
        }
    }

    private func showError(_ error: String) {
        DispatchQueue.main.async {
            self.infoTextView.text = error
            self.infoTextView.layer.borderColor = UIColor.red.cgColor
        }
    }
}

private extension ViewController {
    func getNodeInfo(_ nodeUrl: URL) {
        let apiClient = APIClient(url: nodeUrl)

        do {
            let nodeInfo = try apiClient.localNodeInfo()
            let tipHeader = try apiClient.getTipHeader()

            let result = """
            Node info:
            \tURL: \(nodeUrl.absoluteString)
            \tVersion: \(nodeInfo.version)

            Current tip header:
            \tEpoch: \(tipHeader.epoch)
            \tBlock number: \(tipHeader.number)
            \tTime: \(Date(timeIntervalSince1970: TimeInterval(tipHeader.timestamp)! / 1000).description(with: .current))
            """

            showInfo(result)
        } catch let err {
            let error = """
            Fail to get node info!
            Error: \(err.localizedDescription)

            Make sure you input a correct node URL.
            """

            showError(error)
        }
    }

    func testSendCapacity() throws {
        // Fetch system script which we'll use to generate lock for address
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
        let tx = Transaction(deps: deps, inputs: inputs, outputs: outputs, witnesses: [Witness(data: [])])
        // For now we need to call the `computeTransactionHash` to get the tx hash
        let apiClient = APIClient(url: nodeUrl)
        let txHash = try apiClient.computeTransactionHash(transaction: tx)
        let signedTx = try Transaction.sign(tx: tx, with: privateKey, txHash: txHash)


        // Now send out the capacity
        let hash = try apiClient.sendTransaction(transaction: signedTx)
        print(hash) // hash should equal to txHash
    }
}
