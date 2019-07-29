//
//  APIClient+Net.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    func localNodeInfo() throws -> Node {
        return try load(APIRequest<Node>(method: "local_node_info", params: []))
    }

    func getPeers() throws -> [Node] {
        return try load(APIRequest<[Node]>(method: "get_peers", params: []))
    }

    func setBan(address: String, command: String, banTime: Timestamp?, absolute: Bool?, reason: String?) throws -> Bool {
        _ = try loadNullable(APIRequest<Bool>(method: "set_ban", params: [address, command, banTime, absolute, reason]))
        return true
    }

    func getBannedAddresses() throws -> [BannedAddress] {
        return try load(APIRequest<[BannedAddress]>(method: "get_banned_addresses", params: []))
    }
}
