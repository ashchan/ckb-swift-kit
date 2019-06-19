//
//  APIClient+Stats.swift
//  CKB
//
//  Created by James Chen on 2019/06/19.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension APIClient {
    func getBlockchainInfo() throws -> ChainInfo {
        return try load(APIRequest<ChainInfo>(method: "get_blockchain_info", params: []))
    }

    func getPeersState() throws -> [PeerState] {
        return try load(APIRequest<[PeerState]>(method: "get_peers_state", params: []))
    }
}
