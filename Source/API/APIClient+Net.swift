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
}
