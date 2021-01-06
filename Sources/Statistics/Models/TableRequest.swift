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

struct TableRequest: Encodable {
    var query: [Query]
    let response: [String: String] = ["format": "json"]
}

extension TableRequest {
    static var empty: TableRequest {
        return TableRequest(query: [])
    }
}

// MARK: Query

struct Query: Encodable {
    let code: String
    let selection: Selection
    
    init(code: String, values: [String]) {
        self.code = code
        self.selection = Selection(values: values)
    }
}

// MARK: Selection

struct Selection: Encodable {
    let filter: String = "item"
    let values: [String]
    
    init(values: [String]) {
        self.values = values
    }
}
