//
//  Serializer.swift
//  Pawsome
//
//  Created by Marentilo on 19.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import Foundation

// MARK: - Serializer
struct Serializer {
    /// Return data if it exist
    static func deserialize <T : Codable> (from data : Data, value : T.Type) -> T? {
        let decoder = JSONDecoder()
        let decodedValue : T? = try? decoder.decode(value, from: data)
        return decodedValue
    }
    
    /// Create binary data from given value
    static func serialize <T : Codable> (value : T) -> Data? {
        let encoder = JSONEncoder()
        let encodedValue : Data? = try? encoder.encode(value)
        return encodedValue
    }
}
