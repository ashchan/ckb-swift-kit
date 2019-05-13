//
//  Primitives.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation
import CryptoSwift

public typealias H256 = String // No strict typing for now.
public typealias HexString = String // Present hex format data
public typealias Timestamp = String
public typealias ProposalShortId = [UInt8] // Fixed 10-element array representing short hash.
public typealias Capacity = String
public typealias Number = String // Unsigned (UInt64)
public typealias HexNumber = String
public typealias BlockNumber = String
public typealias EpochNumber = String
public typealias Cycle = String

extension H256 {
    public static let zeroHash: H256 = "0x0000000000000000000000000000000000000000000000000000000000000000"
}

/// Able to convert to API parameters just like toJSON.
public protocol Param {
    var param: [String: Any] { get }
}
