//
//  DynVecSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Vector with non-fixed size inner items.
struct DynVecSerializer: Serializer {
    //
    var header: [Byte]

    var body: [Byte]
}
