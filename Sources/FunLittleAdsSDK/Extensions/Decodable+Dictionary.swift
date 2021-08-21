//
//  Decodable+Dictionary.swift
//  FunLittleAds
//
//  Created by Aaron Vegh on 2021-05-28.
//

import Foundation

enum DecoderError: Error {
    case invalidJSON
}

extension Decodable {
    init(from value: Any,
         options: JSONSerialization.WritingOptions = [.fragmentsAllowed],
         decoder: JSONDecoder) throws {
        guard JSONSerialization.isValidJSONObject(value) else {
            throw DecoderError.invalidJSON
        }
        let data = try JSONSerialization.data(withJSONObject: value, options: options)
        self = try decoder.decode(Self.self, from: data)
    }

    init(from value: Any,
         options: JSONSerialization.WritingOptions = [],
         decoderSetup: ((JSONDecoder) -> Void)? = nil) throws {
        let decoder = JSONDecoder()
        decoderSetup?(decoder)
        try self.init(from: value, options: options, decoder: decoder)
    }
}
