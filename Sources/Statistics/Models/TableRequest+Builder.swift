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
    
    func build() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(tableRequest)
    }
}
