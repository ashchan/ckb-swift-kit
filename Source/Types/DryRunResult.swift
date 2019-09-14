//
//  DryRunResult.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public struct DryRunResult: Codable {
    public let cycles: Cycle

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        cycles = Cycle(hexString: try container.decode(String.self, forKey: .cycles))!
    }
}
