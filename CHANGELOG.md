All notable changes to this project will be documented in this file.
See [Conventional Commits](https://conventionalcommits.org) for commit guidelines.


# [v0.7.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.6.0...v0.7.0) (2019-03-25)


### Bug Fixes

* test bundle damaged issue ([970aefe](https://github.com/nervosnetwork/ckb-sdk-swift/commit/970aefe))


### Features

* add tests for compressed/umcopressed public key computing ([89f2f42](https://github.com/nervosnetwork/ckb-sdk-swift/commit/89f2f42))
* replace secp256k1_swift with secp256k1.swift and implement Secp256k1.privateToPublic ([f1911b8](https://github.com/nervosnetwork/ckb-sdk-swift/commit/f1911b8))
* **lint:** use SwiftLint installed via CocoaPods ([3f06d86](https://github.com/nervosnetwork/ckb-sdk-swift/commit/3f06d86))
* **rpc:** implement local_node_info RPC method ([7c05644](https://github.com/nervosnetwork/ckb-sdk-swift/commit/7c05644))
* **rpc:** implement trace rpc trace_transaction and get_transaction_trace ([744d8b5](https://github.com/nervosnetwork/ckb-sdk-swift/commit/744d8b5))


### BREAKING CHANGES

* Repalce SHA3 with Blake2b.


# [v0.6.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.5.0...v0.6.0) (2019-02-25)

No changes for v0.6.0.


# [v0.5.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.5.0...v0.6.0) (2019-02-11)

### Bug Fixes

* type hash changed by bitcoin_unlock.rb update ([188a0fe](https://github.com/nervosnetwork/ckb-sdk-swift/commit/188a0fe))


### Features

* use ckb-ruby-scripts submodule to include ruby scripts ([af6f834](https://github.com/nervosnetwork/ckb-sdk-swift/commit/af6f834))
