//
//  TransactionSerializer.swift
//
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

public extension Transaction {
    func serialize() -> [UInt8] {
        let serializer = TableSerializer(
            value: self,
            fieldSerializers: [
                // TODO: construct serializers for tx
            ]
        )
        return serializer.serialize()
    }

    func computeHash() -> H256 {
        let serialized = serialize()
        return Blake2b().hash(bytes: serialized)
    }
}
