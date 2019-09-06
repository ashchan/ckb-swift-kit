//
//  Script.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public enum ScriptHashType: String, Codable {
    case data
    case type
}

public struct Script: Codable, Param {
    public let codeHash: H256
    public let hashType: ScriptHashType
    public let args: [HexString]

    enum CodingKeys: String, CodingKey {
        case codeHash = "code_hash"
        case hashType = "hash_type"
        case args
    }

    public var hash: String {
        let serialized = serialize()
        let hash = Blake2b().hash(bytes: serialized)!.toHexString()
        return Utils.prefixHex(hash)
    }

    public var param: [String: Any] {
        return [
            CodingKeys.args.rawValue: args,
            CodingKeys.codeHash.rawValue: codeHash,
            CodingKeys.hashType.rawValue: hashType.rawValue
        ]
    }

    public init(args: [HexString] = [], codeHash: H256 = H256.zeroHash, hashType: ScriptHashType = .data) {
        self.codeHash = Utils.prefixHex(codeHash)
        self.hashType = hashType
        self.args = args
    }
}

// Serialization
extension ScriptHashType {
    var byte: UInt8 {
        return self == .data ? 0x0 : 0x1
    }
}

extension Script {
    func serialize() -> [UInt8] {
        let normalizedArgs: [[Byte]] = args.map { (arg) in
            // TODO: check if Data(hex: arg) needs to left pad arg string
            return Data(hex: arg).bytes
        }
        let serializer = TableSerializer(
            value: self,
            fieldSerializers: [
                Byte32Serializer(value: codeHash)!,
                ByteSerializer(value: hashType.byte),
                DynVecSerializer<[Byte], FixVecSerializer<Byte, ByteSerializer>>(value: normalizedArgs)
            ]
        )
        return serializer.serialize()
    }
}
