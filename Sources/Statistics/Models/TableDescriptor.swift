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
