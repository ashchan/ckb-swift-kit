//
//  APIClient+Net.swift
//  CKB
//
//  Created by James Chen on 2019/06/19.
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
