//
//  VerifyScript.swift
//  CKB
//
//  Created by James Chen on 2018/12/19.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

final class VerifyScript {
    static let script = VerifyScript()
    private let data: Data

    var content: HexString {
        return Utils.prefixHex(data.toHexString())
    }

    private init() {
        // Not using bitcoin_unlock.rb script.
        // let scriptPath = Bundle(for: type(of: self)).path(forResource: "bitcoin_unlock", ofType: "rb")!
        // data = try! Data(contentsOf: URL(fileURLWithPath: scriptPath))
        data = "This will fail!".data(using: .utf8)!
    }
}
