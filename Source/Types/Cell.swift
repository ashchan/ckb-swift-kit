//
//  Cell.swift
//  CKB
//
//  Created by James Chen on 2018/12/14.
//  Copyright © 2018 Nervos Foundation. All rights reserved.
//

import Foundation

public struct CellWithStatus: Codable {
    public let cell: CellOutput?
    public let status: String
}
