# CKB Kit (Swift)

[![Platform](https://img.shields.io/badge/Platforms-macOS%20%7C%20Linux-4e4e4e.svg?colorA=28a745)](#installation)

Swift toolkit for Nervos [CKB](https://github.com/nervosnetwork/ckb).

## Prerequisites

* Xcode 11.4 with Swift 5.2, or higher
* Target of macOS 10.15 or higher
* Swift Package Manager
* [libsodium](https://github.com/jedisct1/libsodium)

## Installation

In your `Package.swift` file, specify this in `dependencies`:

```swift
dependencies: [
  .package(url: "https://github.com/ashchan/ckb-swift-kit", from: "0.29.0")
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

### Send Capacity Example (Using `Payment` class)

```swift
let payment = try! Payment(
    from: "ckt1qyqrdsefa43s6m882pcj53m4gdnj4k440axqswmu83",
    to: "ckt1qyqy0frc0r8kus23ermqkxny662m37yc26fqpcyqky",
    amount: 100  * 100_000_000,
    apiClient: APIClient(url: nodeUrl)
)

let privateKey = Data(hex: "e79f3207ea4980b7fed79956d5934249ceac4751a4fae01a0f7c4a96884bc4e3")
try payment.sign(privateKey: privateKey)
if let txhash = try? payment.send() {
    print(txhash)
}
```
