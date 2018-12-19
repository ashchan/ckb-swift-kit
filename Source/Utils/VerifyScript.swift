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

    var content: [UInt8] {
        return data.bytes
    }

    private init() {
        let scriptPath = Bundle(for: type(of: self)).path(forResource: "bitcoin_unlock", ofType: "rb")!
        data = try! Data(contentsOf: URL(fileURLWithPath: scriptPath))
    }
}
