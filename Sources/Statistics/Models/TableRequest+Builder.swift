//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

public final class TableRequestBuilder {
    private var tableRequest: TableRequest = .empty
    
    public init() {}
    
    @discardableResult
    public func select(_ values: [String]) -> TableRequestBuilder {
        let query = TableQuery(code: "ContentsCode", values: values)
        tableRequest.query.append(query)
        return self
    }
    
    @discardableResult
    public func select(_ values: String...) -> TableRequestBuilder {
        return self.select(values)
    }
    
    @discardableResult
    public func filter(_ code: String, by values: [String]) -> TableRequestBuilder {
        let query = TableQuery(code: code, values: values)
        tableRequest.query.append(query)
        return self
    }
    
    @discardableResult
    public func filter(_ code: String, by value: String) -> TableRequestBuilder {
        return self.filter(code, by: [value])
    }
    
    func build() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(tableRequest)
    }
}
