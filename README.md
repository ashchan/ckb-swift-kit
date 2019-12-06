# CKB SDK Swift

[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20Linux-4e4e4e.svg?colorA=28a745)](#installation)
[![Azure Pipelines](https://dev.azure.com/ashchan/ckb-sdk-swift/_apis/build/status/ashchan.ckb-sdk-swift?branchName=develop)](https://dev.azure.com/ashchan/ckb-sdk-swift/_build/latest?definitionId=7&branchName=develop)
[![TravisCI](https://travis-ci.com/ashchan/ckb-sdk-swift.svg?branch=develop)](https://travis-ci.com/ashchan/ckb-sdk-swift)
[![Codecov](https://codecov.io/gh/ashchan/ckb-sdk-swift/branch/master/graph/badge.svg)](https://codecov.io/gh/ashchan/ckb-sdk-swift/branch/master)

Swift SDK for Nervos [CKB](https://github.com/nervosnetwork/ckb).

The ckb-sdk-swift is still under development and NOT production ready. You should get familiar with CKB transaction structure and RPC before using it.

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

  pod "CKB", git: "https://github.com/ashchan/ckb-sdk-swift.git", tag: "v0.25.0"
end
```

### Swift Package Manager(SPM)

You can also use [Swift Package Manager](https://swift.org/package-manager/). In your `Package.swift` file, specify this in `dependencies`:

```swift
dependencies: [
  .package(url: "https://github.com/ashchan/ckb-sdk-swift", from: "0.25.0")
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

## Getting Help

* More Nervos CKB documentations can be found at the official document website [docs.nervos.org](https://docs.nervos.org).
* Join [CKB Dev](https://t.me/nervos_ckb_dev) Telegram group, or [Nervos Talk](https://talk.nervos.org/) forum.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) file.

## License

CKB Swift SDK is released under the terms of the MIT license. See [LICENSE](LICENSE) for more information or see [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).
