//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

struct TableRequest {
    var query: [TableQuery]
    let response: [String: String] = ["format": "json"]
}

extension TableRequest: Encodable {
    private enum CodingKeys: String, CodingKey {
        case query, response
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(query, forKey: .query)
        try container.encode(response, forKey: .response)
    }
}

extension TableRequest {
    public static var empty: TableRequest {
        return TableRequest(query: [])
    }
}

// MARK: Query

struct TableQuery: Encodable {
    let code: String
    let selection: TableSelection
    
    init(code: String, values: [String]) {
        self.code = code
        self.selection = TableSelection(values: values)
    }
}

// MARK: Selection

struct TableSelection: Encodable {
    let filter: String = "item"
    let values: [String]
    
    init(values: [String]) {
        self.values = values
    }
}
