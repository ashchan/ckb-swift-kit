# CKB SDK Swift

[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20Linux-4e4e4e.svg?colorA=28a745)](#installation)
[![Azure Pipelines](https://dev.azure.com/nervosnetwork/ckb-sdk-swift/_apis/build/status/nervosnetwork.ckb-sdk-swift?branchName=develop)](https://dev.azure.com/nervosnetwork/ckb-sdk-swift/_build/latest?definitionId=7&branchName=develop)
[![TravisCI](https://travis-ci.com/nervosnetwork/ckb-sdk-swift.svg?branch=develop)](https://travis-ci.com/nervosnetwork/ckb-sdk-swift)
[![Codecov](https://codecov.io/gh/nervosnetwork/ckb-sdk-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/nervosnetwork/ckb-sdk-swift/branch/master)
[![Telegram Group](https://cdn.rawgit.com/Patrolavia/telegram-badge/8fe3382b/chat.svg)](https://t.me/nervos_ckb_dev)

Swift SDK for Nervos [CKB](https://github.com/nervosnetwork/ckb).

## Prerequisites

* Xcode 10.2 with Swift 5, or higher
* Target of iOS 11 or higher / macOS 10.13 or higher
* CocoaPods or SPM

## Installation

### CocoaPods

Install [CocoaPods](http://cocoapods.org/?q=cryptoSwift) 1.7.0 or later.

Add this to your `Podfile`:

```ruby
platform :osx, "10.13"

target "MyApp" do
  use_frameworks!
  use_modular_headers!

  pod "CKB", git: "https://github.com/nervosnetwork/ckb-sdk-swift.git", tag: "v0.19.0"
end
```

### Swift Package Manager(SPM)

You can also use [Swift Package Manager](https://swift.org/package-manager/). In your `Package.swift` file, specify this in `dependencies`:

```swift
dependencies: [
  .package(url: "https://github.com/nervosnetwork/ckb-sdk-swift", from: "0.19.0")
]
```

## Getting Started

*Note: Many API methods would throw exception on failure. The following examples all assume that there's a surrounding `do {} catch {}` block or throwing function.*

The `APIClient` class provides JSONRPC access to a CKB node.

```swift
import CKB

// Connect to local node
let nodeUrl = URL(string: "http://localhost:8114")!
let apiClient = APIClient(url: nodeUrl)

// Fetch local node info
let nodeInfo = try apiClient.localNodeInfo()
print(nodeInfo.version)                        // "0.20.0 (rylai-v9 024408ee 2019-09-07)"

// Get current height
let height = try apiClient.getTipBlockNumber() // Numbers are represented as strings
print(height)                                  // "10420"
```

### Send Capacity Example

```swift
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
```

## Getting Help

* More Nervos CKB documentations can be found at the document website [docs.nervos.org](https://docs.nervos.org).
* Join [CKB Dev](https://t.me/nervos_ckb_dev) Telegram group, or [Nervos Talk](https://talk.nervos.org/) forum.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) file.

## License

Nervos CKB SDK is released under the terms of the MIT license. See [LICENSE](LICENSE) for more information or see [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).
