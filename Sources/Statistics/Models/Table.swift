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

/// A table containing the requested statistics.
public struct Table: Decodable {
    /// Table columns.
    public let columns: [Column]
    
    /// Table rows.
    public let rows: [Row]
    
    /// Table comments.
    public let comments: [Comment]
    
    /// Table metadata.
    public let metadata: [Metadata]
    
    private enum CodingKeys: String, CodingKey {
        case columns, rows = "data", comments, metadata
    }
    
    public init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.columns = try container.decode([Column].self, forKey: .columns)
        self.rows = try container.decode([Row].self, forKey: .rows)
        if container.contains(.comments) {
            self.comments = try container.decode([Comment].self, forKey: .comments)
        } else {
            self.comments = []
        }
        self.metadata = try container.decode([Metadata].self, forKey: .metadata)
    }
}

extension Table {
    private func metadata(_ keyPath: KeyPath<Metadata, String>) -> String {
        guard metadata.count > 0 else {
            return ""
        }
        guard metadata.count > 1 else {
            return metadata.first.unsafelyUnwrapped[keyPath: keyPath]
        }
        let values = metadata.map { $0[keyPath: keyPath] }
        return values.dropLast().joined(separator: ", ") + " & " + values.last.unsafelyUnwrapped
    }
    
    /// Table label(s).
    public var label: String {
        return self.metadata(\.label)
    }
    
    /// Table source(s).
    public var source: String {
        return self.metadata(\.source)
    }
    
    /// Table info file(s).
    public var infofile: String {
        return self.metadata(\.infofile)
    }
    
    /// Table update date(s).
    public var updated: String {
        return self.metadata(\.updated)
    }
}

// MARK: - Internals

/// Table column.
public struct Column: Decodable {
    public let code: String
    public let text: String
    public let type: ColumnType
    public let comment: String?
}

extension Column {
    /// Table column type.
    public enum ColumnType: String, Decodable {
        case time = "t"
        case column = "c"
        case data = "d"
        case invalid = ""
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let string = try container.decode(String.self)
            
            self = ColumnType(rawValue: string) ?? .invalid
        }
    }
}

/// Table comment.
public struct Comment: Decodable {
    public let variable: String
    public let value: String
    public let comment: String
}

/// Table row.
public struct Row: Decodable {
    public let key: [String]
    public let values: [String]
}

/// Table metadata.
public struct Metadata: Decodable {
    public let infofile: String
    public let updated: String
    public let label: String
    public let source: String
}
