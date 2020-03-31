//
//  APIClient+Stats.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import CKBFoundation

public extension APIClient {
    func getBlockchainInfo() throws -> ChainInfo {
        return try load(APIRequest<ChainInfo>(method: "get_blockchain_info", params: []))
    }

    func getPeersState() throws -> [PeerState] {
        return try load(APIRequest<[PeerState]>(method: "get_peers_state", params: []))
    }
}
