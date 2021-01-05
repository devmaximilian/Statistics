//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-05.
//

import Foundation

extension Table {
    public struct Row: Decodable {
        let key: [String]
        let values: [String]
    }
}

extension String {
    public var double: Double {
        return Double(self) ?? 0
    }
    
    public var int: Int {
        return Int(self) ?? 0
    }
}
