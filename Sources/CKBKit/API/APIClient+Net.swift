//
//  APIClient+Net.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import CKBFoundation

public extension APIClient {
    func localNodeInfo() throws -> Node {
        return try load(APIRequest<Node>(method: "local_node_info", params: []))
    }

    func getPeers() throws -> [Node] {
        return try load(APIRequest<[Node]>(method: "get_peers", params: []))
    }

    func setBan(address: String, command: String, banTime: Date?, absolute: Bool?, reason: String?) throws -> Bool? {
        let time: String?
        if let banTime = banTime {
            time = UInt64(banTime.timeIntervalSince1970 * 1000).hexString
        } else {
            time = nil
        }
        return try loadNullable(APIRequest<Bool>(
            method: "set_ban",
            params: [address, command, time, absolute, reason])
        )
    }

    func getBannedAddresses() throws -> [BannedAddress] {
        return try load(APIRequest<[BannedAddress]>(method: "get_banned_addresses", params: []))
    }
}
