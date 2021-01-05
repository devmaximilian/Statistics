import Foundation

extension TableDescriptor {
    public enum Variable {
        case column(code: String, text: String, values: [(value: String, text: String)])
        case elimination(code: String, text: String, values: [(value: String, text: String)])
        case time(code: String, text: String, values: [(value: String, text: String)])
        
        var code: String {
            switch self {
                case .column(let code, _, _): return code
                case .elimination(let code, _, _): return code
                case .time(let code, _, _): return code
            }
        }
        
        public var text: String {
            switch self {
                case .column(_, let text, _): return text
                case .elimination(_, let text, _): return text
                case .time(_, let text, _): return text
            }
        }
        
        public var values: [(value: String, text: String)] {
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
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let compositeValues = Array(
            zip(
                try container.decode([String].self, forKey: .values),
                try container.decode([String].self, forKey: .valueTexts)
            )
        )
        
        elimination: if container.contains(.elimination), try container.decode(Bool.self, forKey: .elimination) == true {
            self = .elimination(
                code: try container.decode(String.self, forKey: .code),
                text: try container.decode(String.self, forKey: .text),
                values: compositeValues
            )
            return
        }
        
        time: if container.contains(.time), try container.decode(Bool.self, forKey: .time) == true {
            self = .time(
                code: try container.decode(String.self, forKey: .code),
                text: try container.decode(String.self, forKey: .text),
                values: compositeValues
            )
            return
        }
        
        self = .column(
            code: try container.decode(String.self, forKey: .code),
            text: try container.decode(String.self, forKey: .text),
            values: compositeValues
        )
    }
}
