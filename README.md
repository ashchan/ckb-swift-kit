# CKB SDK Swift

[![TravisCI](https://travis-ci.com/nervosnetwork/ckb-sdk-swift.svg?branch=develop)](https://travis-ci.com/nervosnetwork/ckb-sdk-swift)
[![Telegram Group](https://cdn.rawgit.com/Patrolavia/telegram-badge/8fe3382b/chat.svg)](https://t.me/nervos_ckb_dev)

Swift SDK for Nervos [CKB](https://github.com/nervosnetwork/ckb).

## Prerequisites

* Xcode 10.2 with Swift 5, or higher
* Target of iOS 11 or higher(we have plan to add macOS support in the near future)
* CocoaPods or SPM

## Installation

### CocoaPods

Install [CocoaPods](http://cocoapods.org/?q=cryptoSwift) 1.7.0 or later.

Add this to your `Podfile`:

```ruby
platform :ios, "11.0"

target "MyApp" do
  use_frameworks!
  use_modular_headers!

  pod "CKB", git: "https://github.com/nervosnetwork/ckb-sdk-swift.git", tag: "v0.12.0"
end
```

### Swift Package Manager(SPM)

You can also use [Swift Package Manager](https://swift.org/package-manager/). In your `Package.swift` file, specify this in `dependencies`:

```swift
dependencies: [
  .package(url: "https://github.com/nervosnetwork/ckb-sdk-swift", from: "0.12.0")
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
print(nodeInfo.version)                        // "0.12.0-pre (rylai30-1-g3e765560 2019-05-16)"

// Get current height
let height = try apiClient.getTipBlockNumber() // Numbers are represented as strings
print(height)                                  // "10420"
```

### Send Capacity Example

```swift
// Fetch system script which we'll use to generate lock for address
let nodeUrl = URL(string: "http://localhost:8114")!
let systemScript = try SystemScript.loadFromGenesisBlock(nodeUrl: nodeUrl)
// Fill in the sender's private key
let privateKey: Data = Data(hex: "your private key (hex string)")

// Push system script's out point into deps
let deps = [systemScript.outPoint]

// Gather inputs. For an simple example of how to gather inputs, see our Testnet Faucet's
// [CellService module](https://github.com/nervosnetwork/ckb-testnet-faucet/blob/68205ac338fa3ea3a3f007d8485c15de52cb3abd/faucet-server/Sources/App/Services/CellService.swift#L30-L48).
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
```

## Getting Help

* More Nervos CKB documentations can be found at the document website [docs.nervos.org](https://docs.nervos.org).
* Join [CKB Dev](https://t.me/nervos_ckb_dev) Telegram group, or [Nervos Talk](https://talk.nervos.org/) forum.

## License

Nervos CKB SDK is released under the terms of the MIT license. See [LICENSE](LICENSE) for more information or see [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) file.
