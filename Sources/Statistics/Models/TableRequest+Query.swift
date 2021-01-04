//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

extension TableRequest {
    public struct Query: Encodable {
        let code: String
        let selection: Selection
        
        init(for variable: TableDescriptor.Variable, values: [String]) {
            self.code = variable.code
            self.selection = Selection(values)
        }
        
        init(code: String, values: [String]) {
            self.code = code
            self.selection = Selection(values)
        }
    }
}

extension TableRequest.Query {
    public static func select(_ code: String, values: [String]) -> TableRequest.Query {
        return .init(code: code, values: values)
    }
    
    public static func select(_ code: String, value: String) -> TableRequest.Query {
        return select(code, values: [value])
    }
}
