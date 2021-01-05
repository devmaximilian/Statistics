//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-05.
//

import Foundation

extension Table {
    public struct Column: Decodable {
        let code: String
        let text: String
        let type: DataType
        let comment: String?
    }
}

extension Table.Column {
    public enum DataType: String, Decodable {
        case time = "t"
        case content = "c"
        case data = "d"
        case invalid = ""
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            
            self = DataType(rawValue: string) ?? .invalid
        }
    }
}
