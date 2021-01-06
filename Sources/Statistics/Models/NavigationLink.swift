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

/// A navigation link that refers to a nested navigation structure or a table.
public enum NavigationLink {
    case level(id: String, text: String)
    case table(id: String, text: String, updated: String)
    
    /// The id of a nested navigation structure or a table.
    public var id: String {
        switch self {
            case .level(let string, _): return string
            case .table(let string, _, _): return string
        }
    }
    
    /// A label to display for the link.
    public var label: String {
        switch self {
            case .level(_, let string): return string
            case .table(_, let string, _): return string
        }
    }
    
    /// When the table was updated last.
    /// - Note: Links to nested navigation structures return nil.
    public var updated: String? {
        guard case .table(_, _, let string) = self else {
            return nil
        }
        return string
    }
}

extension NavigationLink: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id, type, text, updated
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)
        
        level: if type == "l" {
            self = .level(
                id: try container.decode(String.self, forKey: .id),
                text: try container.decode(String.self, forKey: .text)
            )
            return
        }
        
        table: if type == "t" {
            self = .table(
                id: try container.decode(String.self, forKey: .id),
                text: try container.decode(String.self, forKey: .text),
                updated: try container.decode(String.self, forKey: .updated)
            )
            return
        }
        
        throw DecodingError.dataCorrupted(
            DecodingError.Context(
                codingPath: decoder.codingPath,
                debugDescription: "Unrecognized link type ”\(type)”"
            )
        )
    }
}

extension NavigationLink {
    /// Link to root navigation structure.
    public static var root: Self {
        return .level(id: "", text: "")
    }
}
