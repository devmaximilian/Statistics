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

/// A table descriptor containing metadata for a table.
public struct TableDescriptor: Decodable {
    public let title: String
    private let variables: [Variable]
}

extension TableDescriptor {
    public var columns: [(label: String, code: String)] {
        return self.variables
            .filter {
                "\($0)".hasPrefix("column")
            }
            .map(\.values)
            .reduce(into: []) {
                $0.append(contentsOf: $1.map {
                    ($0.text, $0.value)
                })
            }
    }
    
    public var filters: [(label: String, code: String, values: [(text: String, value: String)])] {
        return self.variables
            .filter {
                "\($0)".hasPrefix("elimination")
            }
            .map {
                ($0.label, $0.code, $0.values)
            }
    }
    
    public var series: [(label: String, code: String, values: [(text: String, value: String)])] {
        return self.variables
            .filter {
                "\($0)".hasPrefix("time")
            }
            .map {
                ($0.label, $0.code, $0.values)
            }
    }
}

// MARK: - Variable

extension TableDescriptor {
    enum Variable {
        case column(code: String, label: String, values: [(text: String, value: String)])
        case elimination(code: String, label: String, values: [(text: String, value: String)])
        case time(code: String, label: String, values: [(text: String, value: String)])
        
        var code: String {
            switch self {
                case .column(let code, _, _): return code
                case .elimination(let code, _, _): return code
                case .time(let code, _, _): return code
            }
        }
        
        var label: String {
            switch self {
                case .column(_, let label, _): return label
                case .elimination(_, let label, _): return label
                case .time(_, let label, _): return label
            }
        }
        
        var values: [(text: String, value: String)] {
            switch self {
                case .column(_, _, let values): return values
                case .elimination(_, _, let values): return values
                case .time(_, _, let values): return values
            }
        }
    }
}

extension TableDescriptor.Variable: Decodable {
    private enum CodingKeys: String, CodingKey {
        case code, text, values, valueTexts, elimination, time
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let values = Array(
            zip(
                try container.decode([String].self, forKey: .valueTexts),
                try container.decode([String].self, forKey: .values)
            )
        )
        
        elimination: if container.contains(.elimination), try container.decode(Bool.self, forKey: .elimination) == true {
            self = .elimination(
                code: try container.decode(String.self, forKey: .code),
                label: try container.decode(String.self, forKey: .text),
                values: values
            )
            return
        }
        
        time: if container.contains(.time), try container.decode(Bool.self, forKey: .time) == true {
            self = .time(
                code: try container.decode(String.self, forKey: .code),
                label: try container.decode(String.self, forKey: .text),
                values: values
            )
            return
        }
        
        self = .column(
            code: try container.decode(String.self, forKey: .code),
            label: try container.decode(String.self, forKey: .text),
            values: values
        )
    }
}

