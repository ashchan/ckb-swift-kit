//
//  Primitives.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation
import CryptoSwift

public typealias H256 = String // No strict typing for now.
public typealias HexString = String // Present hex format data
public typealias ProposalShortId = [UInt8] // Fixed 10-element array representing short hash.
public typealias HexNumber = String

public typealias BlockNumber = UInt64
public typealias EpochNumber = UInt64
public typealias Capacity = UInt64
public typealias Cycle = UInt64
public typealias Version = UInt32

extension H256 {
    public static let zeroHash: H256 = "0x0000000000000000000000000000000000000000000000000000000000000000"
}

/// Able to convert to API parameters just like toJSON.
public protocol Param {
    var param: [String: Any] { get }
}

public protocol HexStringRepresentable {
    init?(hexString: String)
    var hexString: String { get }
}

public extension HexStringRepresentable where Self: UnsignedInteger & FixedWidthInteger {
    init?(hexString: String) {
        self.init(
            hexString.starts(with: "0x") ? String(hexString.dropFirst(2)) : hexString,
            radix: 16
        )
    }

    var hexString: String {
        return Utils.prefixHex(String(self, radix: 16))
    }
}

extension UInt8: HexStringRepresentable {}
extension UInt16: HexStringRepresentable {}
extension UInt32: HexStringRepresentable {}
extension UInt64: HexStringRepresentable {}

public extension Date {
    init(hexSince1970: String) {
        let timeInterval = UInt64(hexString: hexSince1970)!
        self.init(timeIntervalSince1970: TimeInterval(timeInterval) / 1000)
    }
}
