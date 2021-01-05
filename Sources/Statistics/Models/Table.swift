//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

public struct Table: Decodable {
    let columns: [Column]
    let data: [Row]
//    let comments: [String]
    let metadata: [Details]
}

// TODO: Add specific types of tables, such as single key-table

extension Table {
    public var comments: [(code: String, text: String, comment: String)] {
        return columns.filter {
            $0.comment != nil
        }
        .map {
            ($0.code, $0.text, $0.comment ?? "")
        }
    }
    
    public var singleKey: Bool {
        return data.first?.key.count ?? 1 < 2
    }
}
