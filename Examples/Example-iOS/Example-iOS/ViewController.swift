//
//  ViewController.swift
//
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
            \tTime: \(tipHeader.timestamp.description(with: .current))
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
        let systemScript = try SystemScript.loadSystemScript(nodeUrl: nodeUrl)
        // Fill in the sender's private key
        let privateKey: Data = Data(hex: "your private key (hex string)")

        // Push system script's out point into deps
        let deps = [CellDep(outPoint: systemScript.depOutPoint, depType: .depGroup)]

        // Gather inputs. For an simple example of how to gather inputs, see our Testnet Faucet's [CellService module](https://github.com/nervosnetwork/ckb-testnet-faucet/blob/develop/faucet-server/Sources/App/Services/CellService.swift#L27).
        let inputs: [CellInput] = [/*...*/]

        // Generate lock script for the receiver's address
        let toAddress = "ckt..."
        let publicKeyHash = Utils.prefixHex(AddressGenerator(network: .testnet).publicKeyHash(for: toAddress)!)
        let lockScript = systemScript.lock(for: publicKeyHash)
        // Construct the outputs
        let outputs = [CellOutput(capacity: 500_00_000_000, lock: lockScript, type: nil)]

        // Generate the transaction
        let tx = Transaction(cellDeps: deps, inputs: inputs, outputs: outputs, outputsData: ["0x"], witnesses: [Witness(data: [])])
        // Sign the transaction
        let signedTx = try Transaction.sign(tx: tx, with: privateKey, txHash: tx.computeHash())

        // Now send out the capacity
        let apiClient = APIClient(url: nodeUrl)
        let hash = try apiClient.sendTransaction(transaction: signedTx)
        print(hash) // hash should be equal to txHash
    }
}
