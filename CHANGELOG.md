All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.


# [v0.9.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.8.0...v0.9.0) (2019-04-22)


### Bug Fixes

* Fix public initializers ([37368f0](https://github.com/nervosnetwork/ckb-sdk-swift/commit/37368f0))


### Features

* Change get_cells_by_type_hash to get_cells_by_lock_hash ([6a4f973](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6a4f973))
* Implement Bech32 and address format ([3c38ae3](https://github.com/nervosnetwork/ckb-sdk-swift/commit/3c38ae3))
* Update Bench32 to convert data between 5 bits and 8 bits ([7e46334](https://github.com/nervosnetwork/ckb-sdk-swift/commit/7e46334))
* Remove cellbase from header and uncle block ([931d2ae](https://github.com/nervosnetwork/ckb-sdk-swift/commit/931d2ae))
* Add segregated witness structure ([a418daf](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a418daf))
* Remove index field from witness ([e0f3da2](https://github.com/nervosnetwork/ckb-sdk-swift/commit/e0f3da2))


# [v0.8.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.7.0...v0.8.0) (2019-04-08)


### Features

* Update to Swift 5 ([6b07458](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6b07458))
* Make more interfaces/properties public


### BREAKING CHANGES

* The SDK requires Xcode 10.2 and Swift 5 to build


# [v0.7.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.6.0...v0.7.0) (2019-03-25)


### Bug Fixes

* test bundle damaged issue ([970aefe](https://github.com/nervosnetwork/ckb-sdk-swift/commit/970aefe))


### Features

* add SPM support
* add tests for compressed/umcopressed public key computing ([89f2f42](https://github.com/nervosnetwork/ckb-sdk-swift/commit/89f2f42))
* replace secp256k1_swift with secp256k1.swift and implement Secp256k1.privateToPublic ([f1911b8](https://github.com/nervosnetwork/ckb-sdk-swift/commit/f1911b8))
* **lint:** use SwiftLint installed via CocoaPods ([3f06d86](https://github.com/nervosnetwork/ckb-sdk-swift/commit/3f06d86))
* **rpc:** implement local_node_info RPC method ([7c05644](https://github.com/nervosnetwork/ckb-sdk-swift/commit/7c05644))
* **rpc:** implement trace rpc trace_transaction and get_transaction_trace ([744d8b5](https://github.com/nervosnetwork/ckb-sdk-swift/commit/744d8b5))


### BREAKING CHANGES

* Repalce SHA3 with Blake2b.
* Remove bitcoin_unblock.rb.


# [v0.6.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.5.0...v0.6.0) (2019-02-25)

No changes for v0.6.0.


# [v0.5.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.5.0...v0.6.0) (2019-02-11)

### Bug Fixes

* type hash changed by bitcoin_unlock.rb update ([188a0fe](https://github.com/nervosnetwork/ckb-sdk-swift/commit/188a0fe))


### Features

* use ckb-ruby-scripts submodule to include ruby scripts ([af6f834](https://github.com/nervosnetwork/ckb-sdk-swift/commit/af6f834))
