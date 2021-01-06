import Foundation

extension TableDescriptor {
    public enum Variable {
        case column(code: String, label: String, values: [(text: String, value: String)])
        case elimination(code: String, label: String, values: [(text: String, value: String)])
        case time(code: String, label: String, values: [(text: String, value: String)])
        
        public var code: String {
            switch self {
                case .column(let code, _, _): return code
                case .elimination(let code, _, _): return code
                case .time(let code, _, _): return code
            }
        }
        
        public var label: String {
            switch self {
                case .column(_, let label, _): return label
                case .elimination(_, let label, _): return label
                case .time(_, let label, _): return label
            }
        }
        
        public var values: [(text: String, value: String)] {
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
