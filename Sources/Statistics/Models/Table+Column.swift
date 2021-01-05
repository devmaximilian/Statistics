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
    }
}
