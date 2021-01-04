//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

public struct TableRequest {
    let query: [Query]
    let response: [String: String] = ["format": "json"]
}

extension TableRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case query, response
    }
    
    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(query, forKey: .query)
        try c.encode(response, forKey: .response)
    }
}

extension TableRequest {
    public static var empty: TableRequest {
        return TableRequest(query: [])
    }
}
