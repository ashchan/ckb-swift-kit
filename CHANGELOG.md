# [v0.21.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.20.0...v0.21.0) (2019-09-21)


### Bug Fixes

* CellOutputWithOutPoint decoder for capacity ([ccc5dd2](https://github.com/nervosnetwork/ckb-sdk-swift/commit/ccc5dd2))


### Features

* Add support for parsing hex number to UnsignedIntSerializer ([9c5cadc](https://github.com/nervosnetwork/ckb-sdk-swift/commit/9c5cadc))
* Add UnsignedInteger initializer for parsing hex value ([fdabbec](https://github.com/nervosnetwork/ckb-sdk-swift/commit/fdabbec))
* Define HexStringRepresentable protocol ([bda9101](https://github.com/nervosnetwork/ckb-sdk-swift/commit/bda9101))
* Encode/Parse numbers with hex format for RPC calling ([2ea114c](https://github.com/nervosnetwork/ckb-sdk-swift/commit/2ea114c))
* Implement a simple Payment class that sends capacity ([a92942c](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a92942c))
* Implenment simple LiveCellCollector ([e746470](https://github.com/nervosnetwork/ckb-sdk-swift/commit/e746470))
* Represent timestamp properties as Date type ([74e84d6](https://github.com/nervosnetwork/ckb-sdk-swift/commit/74e84d6))
* Update mocking client tests for parsing RPC numbers ([adf04d9](https://github.com/nervosnetwork/ckb-sdk-swift/commit/adf04d9))
* Update RPC client to use hex numbers ([a2817dc](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a2817dc))



# [v0.20.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.19.0...v0.20.0) (2019-09-07)


### Features

* Add public key hash to lock script util ([c4096d2](https://github.com/nervosnetwork/ckb-sdk-swift/commit/c4096d2))
* Add public key to lock script util ([8dd1844](https://github.com/nervosnetwork/ckb-sdk-swift/commit/8dd1844))
* Extract and make public of TransactionSerializer/ScriptSerializer ([8c79f70](https://github.com/nervosnetwork/ckb-sdk-swift/commit/8c79f70))
* Implement Array Serializer(s) ([b8598fd](https://github.com/nervosnetwork/ckb-sdk-swift/commit/b8598fd))
* Implement ByteSerializer ([eb64ddd](https://github.com/nervosnetwork/ckb-sdk-swift/commit/eb64ddd))
* Implement DynVecSerializer ([a87a8da](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a87a8da))
* Implement FixVecSerializer, refactor other serializers ([16b6186](https://github.com/nervosnetwork/ckb-sdk-swift/commit/16b6186))
* Implement StructSerializer ([6530566](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6530566))
* Implement TableSerializer ([fad544e](https://github.com/nervosnetwork/ckb-sdk-swift/commit/fad544e))
* Implement transaction serialization and other type serializers ([ea0eeeb](https://github.com/nervosnetwork/ckb-sdk-swift/commit/ea0eeeb))
* Re-implement ByteSerializer ([9fecdd1](https://github.com/nervosnetwork/ckb-sdk-swift/commit/9fecdd1))
* Update Script to use Molecule serialization ([013c4b3](https://github.com/nervosnetwork/ckb-sdk-swift/commit/013c4b3))



# [v0.19.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.18.0...v0.19.0) (2019-08-27)


### Features

* Add nonce to header ([792c848](https://github.com/nervosnetwork/ckb-sdk-swift/commit/792c848))
* Calculate system cell type hash ([a5f30c2](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a5f30c2))
* Change isDepGroup boolean to DepType enum ([5f12311](https://github.com/nervosnetwork/ckb-sdk-swift/commit/5f12311))
* Change ScriptHashType values ([c05a069](https://github.com/nervosnetwork/ckb-sdk-swift/commit/c05a069))
* Implement Experiment RPC method _compute_script_hash ([9a67e45](https://github.com/nervosnetwork/ckb-sdk-swift/commit/9a67e45))
* Implement loading system script with dep group ([8dcf84c](https://github.com/nervosnetwork/ckb-sdk-swift/commit/8dcf84c))
* Modify transaction structure ([546fd3d](https://github.com/nervosnetwork/ckb-sdk-swift/commit/546fd3d))
* Remove seal from header ([1dccb23](https://github.com/nervosnetwork/ckb-sdk-swift/commit/1dccb23))



# [v0.18.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.17.0...v0.18.0) (2019-08-10)


### Features

* Add new chain RPC method get_cellbase_output_capacity_details ([85b2f8a](https://github.com/nervosnetwork/ckb-sdk-swift/commit/85b2f8a))
* Add new chain RPC methods get_header, get_header_by_number ([0a9f7af](https://github.com/nervosnetwork/ckb-sdk-swift/commit/0a9f7af))
* Add new net RPC methods set_ban, get_banned_addresses ([df4a7a5](https://github.com/nervosnetwork/ckb-sdk-swift/commit/df4a7a5))



# [v0.17.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.16.0...v0.17.0) (2019-07-27)


### Features

* Add dao field of Header ([6c884dd](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6c884dd))
* Add hash type support ([6b01ab8](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6b01ab8))
* Update address generator as per recent RFC 21 change ([b5e73bb](https://github.com/nervosnetwork/ckb-sdk-swift/commit/b5e73bb))


### BREAKING CHANGES

* A public key will derive different address from previous implementation.
As the code hash index has been changed from 4 bytes to 1 byte, the first serveral fixed
characters will become ckt1qyq from ckb1q9gry5zg and be shorter.


# [v0.16.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.15.0...v0.16.0) (2019-07-13)


* Update to support CKB v0.16.0.


# [v0.15.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.14.0...v0.15.0) (2019-06-29)


### Bug Fixes

* Condition for azure pipelines rpc tests job ([a201c0a](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a201c0a))
* Add missing AlertMessage source file ([b007aed](https://github.com/nervosnetwork/ckb-sdk-swift/commit/b007aed))
* Optional block number param for index_lock_hash rpc method ([fc4a56d](https://github.com/nervosnetwork/ckb-sdk-swift/commit/fc4a56d))


### Features

* Implement indexer RPC ([93b09b6](https://github.com/nervosnetwork/ckb-sdk-swift/commit/93b09b6))
* Implement Secp256k1 recoverable sign ([a5f490c](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a5f490c))
* RPC get_blockchain_info show alerts ([5213e6a](https://github.com/nervosnetwork/ckb-sdk-swift/commit/5213e6a))
* Update Epoch schema ([b98fc04](https://github.com/nervosnetwork/ckb-sdk-swift/commit/b98fc04))
* **example:** Update send tx ([602bdad](https://github.com/nervosnetwork/ckb-sdk-swift/commit/602bdad))
* Use recoverable sign for tx ([be88790](https://github.com/nervosnetwork/ckb-sdk-swift/commit/be88790))


### BREAKING CHANGES

* get_blockchain_info change warnings to alerts


# [v0.14.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.13.0...v0.14.0) (2019-06-15)


### Features

* Add total_tx_cycles/total_tx_size to tx_pool_info RPC response ([8257cfd](https://github.com/nervosnetwork/ckb-sdk-swift/commit/8257cfd))
* Change base project type from iOS to macOS ([675ad86](https://github.com/nervosnetwork/ckb-sdk-swift/commit/675ad86))
* Remove args property from CellInput ([947c89b](https://github.com/nervosnetwork/ckb-sdk-swift/commit/947c89b))
* Throw exception when transaction sign fails ([a344a98](https://github.com/nervosnetwork/ckb-sdk-swift/commit/a344a98))
* Update transaction signing based on new verification model ([ab81c6d](https://github.com/nervosnetwork/ckb-sdk-swift/commit/ab81c6d))


# [v0.13.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.12.0...v0.13.0) (2019-06-01)


### Features

* Add osx support to podspec ([814cb02](https://github.com/nervosnetwork/ckb-sdk-swift/commit/814cb02))
* Add public key hash (blake160) to address methods ([0759ed7](https://github.com/nervosnetwork/ckb-sdk-swift/commit/0759ed7))
* Add total_tx_cycles/total_tx_size to tx_pool_info RPC response ([7c3a191](https://github.com/nervosnetwork/ckb-sdk-swift/commit/7c3a191))


# [v0.12.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.11.0...v0.12.0) (2019-05-18)


### Features

* Add address to publicKeyHash ([ae42882](https://github.com/nervosnetwork/ckb-sdk-swift/commit/ae42882))
* Add system script loading ([c9f06bb](https://github.com/nervosnetwork/ckb-sdk-swift/commit/c9f06bb))
* Generalize OutPoint struct to reference headers ([28bf93a](https://github.com/nervosnetwork/ckb-sdk-swift/commit/28bf93a))
* Implement experiment RPC methods ([f9d389d](https://github.com/nervosnetwork/ckb-sdk-swift/commit/f9d389d))
* Implement get_current_epoch RPC method ([be20881](https://github.com/nervosnetwork/ckb-sdk-swift/commit/be20881))
* Implement get_epoch_by_number RPC method ([2e7a96a](https://github.com/nervosnetwork/ckb-sdk-swift/commit/2e7a96a))
* Implement get_peers RPC method ([abecb54](https://github.com/nervosnetwork/ckb-sdk-swift/commit/abecb54))
* Implement Stats RPC methods ([52ad9f5](https://github.com/nervosnetwork/ckb-sdk-swift/commit/52ad9f5))
* Implement transaction sign ([bfcb656](https://github.com/nervosnetwork/ckb-sdk-swift/commit/bfcb656))
* Remove always success script ([96a80c9](https://github.com/nervosnetwork/ckb-sdk-swift/commit/96a80c9))
* **secp256k1:** Implement ECDSA sign, add test JSON fixture ([fa28824](https://github.com/nervosnetwork/ckb-sdk-swift/commit/fa28824))
* Implement tx_pool_info RPC method ([6432afc](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6432afc))
* Stringify RPC number type ([43c2fa9](https://github.com/nervosnetwork/ckb-sdk-swift/commit/43c2fa9))
* Update Header.proposalsRoot to Header.proposalsHash ([5311a0c](https://github.com/nervosnetwork/ckb-sdk-swift/commit/5311a0c))
* Update the `param` function of `OutPoint` ([df1c1d0](https://github.com/nervosnetwork/ckb-sdk-swift/commit/df1c1d0))


* Remove trace RPC methods ([b0f70b6](https://github.com/nervosnetwork/ckb-sdk-swift/commit/b0f70b6))


### Bug Fixes

* Modify data type of `CellOutputWithOutPoint.lock` ([6a5f6c9](https://github.com/nervosnetwork/ckb-sdk-swift/commit/6a5f6c9))
* RPC request/response id unmatch issue ([8872a85](https://github.com/nervosnetwork/ckb-sdk-swift/commit/8872a85))


### BREAKING CHANGES

* Trace RPC methods are removed.


# [v0.11.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.10.0...v0.11.0) (2019-05-14)


### Bug Fixes

* Fix test ([607512f](https://github.com/nervosnetwork/ckb-sdk-swift/commit/607512f))


### Features

* Add an empty example iOS app ([3bf41b2](https://github.com/nervosnetwork/ckb-sdk-swift/commit/3bf41b2))
* Implement get_block_by_number RPC method ([cc3e3a1](https://github.com/nervosnetwork/ckb-sdk-swift/commit/cc3e3a1))


# [v0.10.0](https://github.com/nervosnetwork/ckb-sdk-swift/compare/v0.9.0...v0.10.0) (2019-05-06)


### Features

* Change RPC types per CKB change ([c2f79ab](https://github.com/nervosnetwork/ckb-sdk-swift/commit/c2f79ab))


### BREAKING CHANGES

* RPC types and fields are changed and client needs to update to adapt.


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
