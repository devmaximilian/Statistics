//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

public struct TableDescriptor {
    public let title: String
    let variables: [Variable]
}

// MARK: Decodable conformance

extension TableDescriptor: Decodable {
    private enum CodingKeys: String, CodingKey {
        case title, variables
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.title = try container.decode(String.self, forKey: .title)
        self.variables = try container.decode([Variable].self, forKey: .variables)
    }
}
