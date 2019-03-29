//
//  TxTrace.swift
//  CKB
//
//  Created by James Chen on 2019/03/01.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public enum Action: String, Codable {
    case addPending = "AddPending"
    case proposed = "Proposed"
    case addCommit = "AddCommit"
    case timeout = "Timeout"
    case addOrphan = "AddOrphan"
    case committed = "Committed"
}

public struct TxTrace: Codable {
    public let action: Action
    public let info: String
    public let time: UInt64
}
