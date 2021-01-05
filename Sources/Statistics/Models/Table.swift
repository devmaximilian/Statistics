import Foundation

public struct Table: Decodable {
    let columns: [TableColumn]
    let data: [TableRow]
    let comments: [String]
    let metadata: [TableDetails]
    
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

struct TableColumn: Decodable {
    let code: String
    let text: String
    let type: DataType
    let comment: String?
}

enum DataType: String, Decodable {
    case time = "t"
    case content = "c"
    case data = "d"
    case invalid = ""
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        self = DataType(rawValue: string) ?? .invalid
    }
}

// MARK: Row

struct TableRow: Decodable {
    let key: [String]
    let values: [String]
}

// MARK: Details

struct TableDetails: Decodable {
    let infofile: String
    let updated: String
    let label: String
    let source: String
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
