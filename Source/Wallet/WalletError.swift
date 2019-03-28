//
//  WalletError.swift
//  CKB
//
//  Created by 翟泉 on 2019/3/28.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import UIKit

public enum WalletError: LocalizedError {
    case tooLowCapacity(min: Capacity)
    case notEnoughCapacity(required: Capacity, available: Capacity)

    var localizedDescription: String {
        switch self {
        case .tooLowCapacity(let min):
            return "Capacity cannot less than \(min)"
        case .notEnoughCapacity(let required, let available):
            return "Not enough capacity, required: \(required), available: \(available)"
        }
    }
}
