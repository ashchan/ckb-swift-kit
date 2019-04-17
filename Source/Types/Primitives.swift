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
public typealias UInt256 = String // e.g. 0x400, TODO: Define a custom type?
public typealias HexString = String // Present hex format data
public typealias ProposalShortId = [UInt8] // Fixed 10-element array representing short hash.
public typealias Capacity = String
public typealias BlockNumber = String

extension H256 {
    public static let zeroHash: H256 = "0000000000000000000000000000000000000000000000000000000000000000"
}

/// Able to convert to API parameters just like toJSON.
public protocol Param {
    var param: [String: Any] { get }
}
