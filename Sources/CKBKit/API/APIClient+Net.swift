//
//  APIClient+Net.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Combine
import CKBFoundation

public extension APIClient {
    func localNodeInfo() -> Future<Node, APIError> {
        load(APIRequest<Node>(method: "local_node_info", params: []))
    }

    func getPeers() -> Future<[Node], APIError> {
        load(APIRequest<[Node]>(method: "get_peers", params: []))
    }
}
