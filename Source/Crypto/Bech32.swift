//
//  Bech32.swift
//  CKB
//
//  Created by James Chen on 2019/04/15.
//  Copyright © 2019 Nervos Foundation. All rights reserved.
//

import Foundation

/// Base32 address format
/// [BIP-0173](https://github.com/bitcoin/bips/blob/master/bip-0173.mediawiki)
class Bech32 {
    private let characters = "qpzry9x8gf2tvdw0s3jn54khce6mua7l".map(String.init)
    private let generator = [0x3b6a57b2, 0x26508e6d, 0x1ea119fa, 0x3d4233dd, 0x2a1462b3]
    private let separator = "1"
    private let checksumLength = 6

    func polymod(values: Data) -> Int {
        var chk = 1
        for v in values.bytes {
            let b = chk >> 25
            chk = (chk & 0x1ffffff) << 5 ^ Int(v)
            generator.enumerated().forEach { (i, g) in
                if (b >> i) & 1 != 0 {
                    chk ^= g
                }
            }
        }
        return chk
    }

    func expand(hrp: String) -> Data {
        let data = hrp.data(using: .utf8)!
        let bytes = data.map { $0 >> 5 } + [0] + data.map { $0 & 31 }
        return Data(bytes)
    }

    func createChecksum(hrp: String, data: Data) -> Data {
        let values = expand(hrp: hrp) + data
        let mod = polymod(values: values + Array(repeating: 0, count: checksumLength)) ^ 1
        let checksum = (0..<checksumLength).map { (mod >> (5 * (5 - $0))) & 31 }
        return Data(checksum.map(UInt8.init))
    }

    func verifyChecksum(hrp: String, data: Data) -> Bool {
        return polymod(values: expand(hrp: hrp) + data) == 1
    }
}

// MARK: - Encode & Decode
extension Bech32 {
    func encode(hrp: String, data: Data) -> String {
        let convertedData = convertBits(data: data, fromBits: 8, toBits: 5, pad: true)!
        let checksum = createChecksum(hrp: hrp, data: convertedData)
        return hrp + separator + (convertedData + checksum).map { characters[Int($0)] }.joined()
    }

    func decode(bech32: String) -> (hrp: String, data: Data)? {
        if bech32.count > 90 {
            return nil
        }

        if bech32 != bech32.lowercased() && bech32 != bech32.uppercased() {
            return nil
        }

        guard !(bech32.utf8.contains { $0 < 33 || $0 > 126 }) else {
            return nil
        }

        guard let indexOfSeparator = bech32.lastIndex(of: Character(separator)) else {
            return nil
        }
        let posOfSeparator = bech32.distance(from: bech32.startIndex, to: indexOfSeparator)
        if posOfSeparator < 1 || posOfSeparator + checksumLength + 1 > bech32.count {
            return nil
        }

        let hrp = String(bech32.prefix(posOfSeparator)).lowercased()
        var data = Data()
        for char in bech32.dropFirst(hrp.count + 1) {
            guard let pos = characters.firstIndex(of: String(char).lowercased()) else {
                return nil
            }
            data.append(UInt8(pos))
        }

        guard verifyChecksum(hrp: hrp, data: data) else {
            return nil
        }

        guard let convertedData = convertBits(
            data: data.dropLast(checksumLength),
            fromBits: 5,
            toBits: 8,
            pad: false
        ) else {
            return nil
        }
        return (hrp: hrp, data: convertedData)
    }

    private func convertBits(data: Data, fromBits: Int, toBits: Int, pad: Bool) -> Data? {
        var ret = Data()
        var acc = 0
        var bits = 0
        let maxv = (1 << toBits) - 1
        for p in 0..<data.count {
            let value = data[p]
            if value < 0 || (value >> fromBits) != 0 {
                return nil
            }
            acc = (acc << fromBits) | Int(value)
            bits += fromBits
            while bits >= toBits {
                bits -= toBits
                ret.append(UInt8((acc >> bits) & maxv))
            }
        }
        if pad {
            if bits > 0 {
                ret.append(UInt8((acc << (toBits - bits)) & maxv))
            }
        } else if bits >= fromBits || ((acc << (toBits - bits)) & maxv) > 0 {
            return nil
        }
        return ret
    }
}
