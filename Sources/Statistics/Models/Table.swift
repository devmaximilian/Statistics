import Foundation

public struct Table: Decodable {
    public let columns: [TableColumn]
    public let data: [TableRow]
    public let comments: [String]
    public let metadata: [TableDetails]
    
    public init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.columns = try container.decode([TableColumn].self, forKey: .columns)
        self.data = try container.decode([TableRow].self, forKey: .data)
        if container.contains(.comments) {
            self.comments = try container.decode([String].self, forKey: .comments)
        } else {
            self.comments = []
        }
        self.metadata = try container.decode([TableDetails].self, forKey: .metadata)
    }
}

// TODO: Add specific types of tables, such as single key-table

// MARK: Column

public struct TableColumn: Decodable {
    public let code: String
    public let text: String
    public let type: DataType
    public let comment: String?
}

public enum DataType: String, Decodable {
    case time = "t"
    case content = "c"
    case data = "d"
    case invalid = ""
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        self = DataType(rawValue: string) ?? .invalid
    }
}

// MARK: Row

public struct TableRow: Decodable {
    public let key: [String]
    public let values: [String]
}

// MARK: Details

public struct TableDetails: Decodable {
    public let infofile: String
    public let updated: String
    public let label: String
    public let source: String
}

// MARK: Convenience

extension String {
    var double: Double {
        return Double(self) ?? 0
    }
    
    var int: Int {
        return Int(self) ?? 0
    }
}
