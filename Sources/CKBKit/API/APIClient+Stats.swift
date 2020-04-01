//
//  APIClient+Stats.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation
import Combine
import CKBFoundation

public extension APIClient {
    func getBlockchainInfo() -> Future<ChainInfo, APIError> {
        load(APIRequest(method: "get_blockchain_info", params: []))
    }

    func getPeersState() -> Future<[PeerState], APIError> {
        load(APIRequest(method: "get_peers_state", params: []))
    }
}
