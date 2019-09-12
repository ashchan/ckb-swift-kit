//
//  Cell.swift
//
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellWithStatus: Codable {
    public let cell: CellInfo?
    public let status: String
}

public struct CellData: Codable {
    public let content: HexString
    public let hash: H256
}

public struct CellInfo: Codable {
    public let output: CellOutput
    public let data: CellData?
}

public struct LiveCell: Codable {
    public let createdBy: TransactionPoint
    public let cellOutput: CellOutput

    enum CodingKeys: String, CodingKey {
        case createdBy = "created_by"
        case cellOutput = "cell_output"
    }
}
