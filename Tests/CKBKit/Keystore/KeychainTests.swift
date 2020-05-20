import XCTest
import CKBFoundation
@testable import CKBKit

class KeychainTests: XCTestCase {
    let shortSeed = Data(hex: "000102030405060708090a0b0c0d0e0f")
    let longSeed = Data(hex: "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542")

    func testMasterFromShortSeed() {
        let master = Keychain(seed: shortSeed)
        XCTAssertEqual(master.privateKey.toHexString(), "e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35")
        XCTAssertEqual(master.chainCode.toHexString(), "873dff81c02f525623fd1fe5167eac3a55a049de3d314bb42ee227ffed37d508")
        XCTAssertEqual(master.fingerprint, 876747070)
        XCTAssertEqual(master.index, 0)
        XCTAssertEqual(master.depth, 0)
        XCTAssertEqual(master.parentFingerprint, 0)
    }

    func testMasterFromLongSeed() {
        let master = Keychain(seed: longSeed)
        XCTAssertEqual(master.privateKey.toHexString(), "4b03d6fc340455b363f51020ad3ecca4f0850280cf436c70c727923f6db46c3e")
        XCTAssertEqual(master.chainCode.toHexString(), "60499f801b896d83179a4374aeb7822aaeaceaa0db1f85ee3e904c4defbd9689")
        XCTAssertEqual(master.fingerprint, 3172384485)
        XCTAssertEqual(master.index, 0)
        XCTAssertEqual(master.depth, 0)
        XCTAssertEqual(master.parentFingerprint, 0)
    }

    func testChildHardened() {
        let master = Keychain(seed: shortSeed)
        let child = master.derivedKeychain(at: 0, hardened: true)
        XCTAssertEqual(child.privateKey.toHexString(), "edb2e14f9ee77d26dd93b4ecede8d16ed408ce149b6cd80b0715a2d911a0afea")
        XCTAssertEqual(child.chainCode.toHexString(), "47fdacbd0f1097043b78c63c20c34ef4ed9a111d980047ad16282c7ae6236141")
        XCTAssertEqual(child.fingerprint, 1545328200)
        XCTAssertEqual(child.index, 0)
        XCTAssertEqual(child.depth, 1)
        XCTAssertEqual(child.parentFingerprint, 876747070)
    }

    func testChildNonHardened() {
        let master = Keychain(seed: longSeed)
        let child = master.derivedKeychain(at: 0, hardened: false)
        XCTAssertEqual(child.privateKey.toHexString(), "abe74a98f6c7eabee0428f53798f0ab8aa1bd37873999041703c742f15ac7e1e")
        XCTAssertEqual(child.chainCode.toHexString(), "f0909affaa7ee7abe5dd4e100598d4dc53cd709d5a5c2cac40e7412f232f7c9c")
        XCTAssertEqual(child.fingerprint, 1516371854)
        XCTAssertEqual(child.index, 0)
        XCTAssertEqual(child.depth, 1)
        XCTAssertEqual(child.parentFingerprint, 3172384485)
    }

    func testDerivePath() {
        let master = Keychain(seed: shortSeed)
        XCTAssertEqual(
            master.derivedKeychain(with: "m/0'")?.privateKey.toHexString(),
            "edb2e14f9ee77d26dd93b4ecede8d16ed408ce149b6cd80b0715a2d911a0afea"
        )
        let child = master.derivedKeychain(with: "m/0'/1/2'")!
        XCTAssertEqual(child.privateKey.toHexString(), "cbce0d719ecf7431d88e6a89fa1483e02e35092af60c042b1df2ff59fa424dca")
        XCTAssertEqual(child.chainCode.toHexString(), "04466b9cc8e161e966409ca52986c584f07e9dc81f735db683c3ff6ec7b1503f")
        XCTAssertEqual(child.fingerprint, 4001020172)
        XCTAssertEqual(child.index, 2)
        XCTAssertEqual(child.depth, 3)
    }

    func testDerivePathWithLargeIndex() {
        let master = Keychain(seed: longSeed)
        XCTAssertEqual(
            master.derivedKeychain(with: "m")?.privateKey.toHexString(),
            "4b03d6fc340455b363f51020ad3ecca4f0850280cf436c70c727923f6db46c3e"
        )
        var child = master.derivedKeychain(with: "0/2147483647'")!
        XCTAssertEqual(child.privateKey.toHexString(), "877c779ad9687164e9c2f4f0f4ff0340814392330693ce95a58fe18fd52e6e93")
        XCTAssertEqual(child.chainCode.toHexString(), "be17a268474a6bb9c61e1d720cf6215e2a88c5406c4aee7b38547f585c9a37d9")
        XCTAssertEqual(child.fingerprint, 3635104055)
        XCTAssertEqual(child.index, 2147483647)
        XCTAssertEqual(child.depth, 2)

        child = child.derivedKeychain(at: 1, hardened: false)
        XCTAssertEqual(child.privateKey.toHexString(), "704addf544a06e5ee4bea37098463c23613da32020d604506da8c0518e1da4b7")
        XCTAssertEqual(child.chainCode.toHexString(), "f366f48f1ea9f2d1d3fe958c95ca84ea18e4c4ddb9366c336c927eb246fb38cb")
        XCTAssertEqual(child.fingerprint, 2017537594)
        XCTAssertEqual(child.index, 1)
        XCTAssertEqual(child.depth, 3)

        child = child.derivedKeychain(at: 2147483646, hardened: true)
        XCTAssertEqual(child.privateKey.toHexString(), "f1c7c871a54a804afe328b4c83a1c33b8e5ff48f5087273f04efa83b247d6a2d")
        XCTAssertEqual(child.chainCode.toHexString(), "637807030d55d01f9a0cb3a7839515d796bd07706386a6eddf06cc29a65a0e29")
        XCTAssertEqual(child.fingerprint, 832899000)
        XCTAssertEqual(child.index, 2147483646)
        XCTAssertEqual(child.depth, 4)
    }

    func testDeriveCkbSeed() {
        let master = Keychain(seed: shortSeed)
        let extended = master.derivedKeychain(with: "m/44'/309'/0'")
        XCTAssertEqual(extended?.privateKey.toHexString(), "bb39d218506b30ca69b0f3112427877d983dd3cd2cabc742ab723e2964d98016")
        XCTAssertEqual(extended?.publicKey.toHexString(), "03e5b310636a0f6e7dcdfffa98f28d7ed70df858bb47acf13db830bfde3510b3f3")
        XCTAssertEqual(extended?.chainCode.toHexString(), "37e85a19f54f0a242a35599abac64a71aacc21e3a5860dd024377ffc7e6827d8")

        let addressKey = extended?.derivedKeychain(at: 0, hardened: false).derivedKeychain(at: 0, hardened: false)
        XCTAssertEqual(addressKey?.privateKey.toHexString(), "fcba4708f1f07ddc00fc77422d7a70c72b3456f5fef3b2f68368cdee4e6fb498")
        XCTAssertEqual(addressKey?.publicKey.toHexString(), "0331b3c0225388c5010e3507beb28ecf409c022ef6f358f02b139cbae082f5a2a3")
        XCTAssertEqual(addressKey?.chainCode.toHexString(), "c4b7aef857b625bbb0497267ed51151d090f81737f4f22a0ac3673483b927090")
    }

    func testDeriveCkbSeed2() {
        // Phrase: tank planet champion pottery together intact quick police asset flower sudden question
        let seed = Data(hex: "1371018cfad5990f5e451bf586d59c3820a8671162d8700533549b0df61a63330e5cd5099a5d3938f833d51e4572104868bfac7cfe5b4063b1509a995652bc08")
        let master = Keychain(seed: seed)
        XCTAssertEqual(master.privateKey.toHexString(), "37d25afe073a6ba17badc2df8e91fc0de59ed88bcad6b9a0c2210f325fafca61")
        let extended = master.derivedKeychain(with: "m/44'/309'/0'")
        XCTAssertEqual(extended?.privateKey.toHexString(), "2925f5dfcbee3b6ad29100a37ed36cbe92d51069779cc96164182c779c5dc20e")

        XCTAssertEqual(master.derivedKeychain(with: "m/44'/309'/0'/0")?.privateKey.toHexString(), "047fae4f38b3204f93a6b39d6dbcfbf5901f2b09f6afec21cbef6033d01801f1")
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'")?
                .derivedKeychain(at: 0, hardened: false)
                .privateKey.toHexString(),
            "047fae4f38b3204f93a6b39d6dbcfbf5901f2b09f6afec21cbef6033d01801f1"
        )
        XCTAssertEqual(master.derivedKeychain(with: "m/44'/309'/0'/0/0")?.privateKey.toHexString(), "848422863825f69e66dc7f48a3302459ec845395370c23578817456ad6b04b14")
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'")?
                .derivedKeychain(at: 0, hardened: false)
                .derivedKeychain(at: 0, hardened: false)
                .privateKey.toHexString(),
            "848422863825f69e66dc7f48a3302459ec845395370c23578817456ad6b04b14"
        )
    }

    func testDeriveCkbFromMaster() {
        let master = Keychain(
            privateKey: Data(hex: "37d25afe073a6ba17badc2df8e91fc0de59ed88bcad6b9a0c2210f325fafca61"),
            chainCode: Data(hex: "5f772d1e3cfee5821911aefa5e8f79d20d4cf6678378d744efd08b66b2633b80")
        )
        XCTAssertEqual(master.publicKey.toHexString(), "020720a7a11a9ac4f0330e2b9537f594388ea4f1cd660301f40b5a70e0bc231065")
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'")?.privateKey.toHexString(),
            "2925f5dfcbee3b6ad29100a37ed36cbe92d51069779cc96164182c779c5dc20e"
        )
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'")!.derivedKeychain(at: 0, hardened: false).privateKey.toHexString(),
            "047fae4f38b3204f93a6b39d6dbcfbf5901f2b09f6afec21cbef6033d01801f1"
        )
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'/0")!.privateKey.toHexString(),
            "047fae4f38b3204f93a6b39d6dbcfbf5901f2b09f6afec21cbef6033d01801f1"
        )
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'")!.derivedKeychain(at: 0, hardened: false).derivedKeychain(at: 0, hardened: false).privateKey.toHexString(),
            "848422863825f69e66dc7f48a3302459ec845395370c23578817456ad6b04b14"
        )
        XCTAssertEqual(
            master.derivedKeychain(with: "m/44'/309'/0'/0/0")?.privateKey.toHexString(),
            "848422863825f69e66dc7f48a3302459ec845395370c23578817456ad6b04b14"
        )
    }

    func testDeriveFromPublicKey() {
        let child = Keychain(
            publicKey: Data(hex: "0357bfe1e341d01c69fe5654309956cbea516822fba8a601743a012a7896ee8dc2"),
            chainCode: Data(hex: "04466b9cc8e161e966409ca52986c584f07e9dc81f735db683c3ff6ec7b1503f"),
            path: "m/0'/1/2'"
        )
        XCTAssertEqual(child.fingerprint, 4001020172)
        XCTAssertEqual(child.index, 2)
        XCTAssertEqual(child.depth, 3)

        let grandchild = child.derivedKeychain(at: 2, hardened: false)
        XCTAssertEqual(grandchild.publicKey.toHexString(), "02e8445082a72f29b75ca48748a914df60622a609cacfce8ed0e35804560741d29")
        XCTAssertEqual(grandchild.chainCode.toHexString(), "cfb71883f01676f587d023cc53a35bc7f88f724b1f8c2892ac1275ac822a3edd")
        XCTAssertEqual(grandchild.fingerprint, 3632322520)
        XCTAssertEqual(grandchild.index, 2)
        XCTAssertEqual(grandchild.depth, 4)
    }

    func testDeriveFromXpubkey() {
        // Phrase: select scout crash enforce riot rival spring whale hollow radar rule sentence
        // Seed: c78e8e1b62dce737243c95ae58953c344d5cfeab2c7d2c15effa0029fa801611d89c956731ff2fe8bb2231b30d025322d4a7d4f422e72266693bc1e84af0596b
        let xpubkey = Data(hex: "03e15b08cd5f04a2263f614ae788ec7efc16f23aad8bf427548674d2720887976f" + "1281863be3136a102e5bcb545d97192071f11cb50a63e7ef535c63449900b2e9")
        let extended = Keychain(publicKey: xpubkey[0..<33], chainCode: xpubkey[33..<65], path: "m/44'/309'/0'")
        let derived = extended.derivedKeychain(with: "0/0")!
        XCTAssertEqual(derived.publicKey.toHexString(), "0255fa485655b06798b45a5f6f69e79c6ebe31fa0018f60989cdacfe67431c37e7")
    }
}
