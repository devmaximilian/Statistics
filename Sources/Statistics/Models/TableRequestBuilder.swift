// MIT License
//
// Copyright (c) 2021 Maximilian Wendel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

/// A table request builder used to specify the data to retrieve.
public final class TableRequestBuilder {
    private var tableRequest: TableRequest = .empty
    
    init() {}
    
    func build() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(tableRequest)
    }
    
    private func append(code: String, values: [String]) -> TableRequestBuilder {
        let query = Query(code: code, values: values)
        tableRequest.query.append(query)
        return self
    }
    
    // MARK: Select
    
    @discardableResult
    public func select(_ values: [String]) -> TableRequestBuilder {
        return self.append(code: "ContentsCode", values: values)
    }
    
    @discardableResult
    public func select(_ values: String...) -> TableRequestBuilder {
        return self.select(values)
    }
    
    @discardableResult
    public func select(_ values: (label: String, code: String)...) -> TableRequestBuilder {
        return self.select(values.map(\.code))
    }
    
    // MARK: Filter
    
    @discardableResult
    public func filter(_ code: String, by values: [String]) -> TableRequestBuilder {
        return self.append(code: code, values: values)
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
    
    // MARK: Between
    
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
        return self.append(code: variable.code, values: values)
    }
    
    @discardableResult
    public func between(_ start: (text: String, value: String)? = nil, _ stop: (text: String, value: String)? = nil, using variable: (label: String, code: String, values: [(text: String, value: String)])) -> TableRequestBuilder {
        return self.between(start?.value, stop?.value, using: variable)
    }
    
    @discardableResult
    public func between(_ start: CustomStringConvertible, _ stop: CustomStringConvertible) -> TableRequestBuilder {
        guard let start = Int(start.description), let stop = Int(stop.description) else {
            return self
        }
        var values: [String] = []
        for i in Int(start)...Int(stop) {
            values.append(i.description)
        }
        return self.append(code: "Tid", values: values)
    }
}
