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

Install [CocoaPods](http://cocoapods.org/?q=cryptoSwift) 1.7.0.rc.2 or later.

Add this to your `Podfile`:

    platform :ios, "11.0"

    target "MyApp" do
      use_frameworks!
      use_modular_headers!

      pod "CKB", git: "https://github.com/nervosnetwork/ckb-sdk-swift.git", tag: "v0.12.0"
    end

### Swift Package Manager(SPM)

You can also use [Swift Package Manager](https://swift.org/package-manager/). In your `Package.swift` file, specify this in `dependencies`:

    dependencies: [
      .package(url: "https://github.com/nervosnetwork/ckb-sdk-swift", from: "0.12.0")
    ]

## License

Nervos CKB SDK is released under the terms of the MIT license. See [LICENSE](LICENSE) for more information or see [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT).

## Changelog

See [CHANGELOG.md](CHANGELOG.md) file.
