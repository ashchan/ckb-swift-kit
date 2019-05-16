//
//  TestHelper.swift
//  CKB
//
//  Created by James Chen on 2019/05/15.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

final class TestHelper {
    static func load(json path: String) -> Data {
        let path = Bundle(for: self).path(forResource: path, ofType: "json")!
        return try! Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }

    static func load(json path: String) -> [String: Any] {
        let data: Data = load(json: path)
        return try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
    }
}
