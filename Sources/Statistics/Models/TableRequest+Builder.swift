import Foundation

public final class TableRequestBuilder {
    private var tableRequest: TableRequest = .empty
    
    init() {}
    
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
    public func select(_ values: (label: String, code: String)...) -> TableRequestBuilder {
        return self.select(values.map(\.code))
    }
    
    @discardableResult
    public func filter(_ code: String, by values: [String]) -> TableRequestBuilder {
        let query = TableQuery(code: code, values: values)
        tableRequest.query.append(query)
        return self
    }
    
    @discardableResult
    public func filter(_ code: String, by values: String...) -> TableRequestBuilder {
        return self.filter(code, by: values)
    }
    
    @discardableResult
    public func filter(_ item: (label: String, code: String, values: [(text: String, value: String)]), by values: [String]) -> TableRequestBuilder {
        return self.filter(item.code, by: values)
    }
    
    @discardableResult
    public func filter(_ item: (label: String, code: String, values: [(text: String, value: String)]), by values: String...) -> TableRequestBuilder {
        return self.filter(item.code, by: values)
    }
    
    @discardableResult
    public func between(_ start: String? = nil, _ stop: String? = nil, using variable: (label: String, code: String, values: [(text: String, value: String)])) -> TableRequestBuilder {
        let values = variable.values.map(\.value).filter {
            if let start = start {
                guard $0 >= start else {
                    return false
                }
            }
            if let stop = stop {
                guard $0 <= stop else {
                    return false
                }
            }
            
            return true
        }
        return self.filter(variable.code, by: values)
    }
    
    @discardableResult
    public func between(_ start: (text: String, value: String)? = nil, _ stop: (text: String, value: String)? = nil, using variable: (label: String, code: String, values: [(text: String, value: String)])) -> TableRequestBuilder {
        return self.between(start?.value, stop?.value, using: variable)
    }
    
    func build() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(tableRequest)
    }
}
