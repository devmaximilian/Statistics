public enum NavigationLink {
    case level(id: String, text: String)
    case table(id: String, text: String, updated: String)
    
    public var id: String {
        switch self {
            case .level(let string, _): return string
            case .table(let string, _, _): return string
        }
    }
    
    public var text: String {
        switch self {
            case .level(_, let string): return string
            case .table(_, let string, _): return string
        }
    }
    
    public var updated: String? {
        guard case .table(_, _, let string) = self else {
            return nil
        }
        return string
    }
}

// MARK: Decodable conformance

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
                debugDescription: "Unrecognized type ”\(type)”"
            )
        )
    }
}

extension NavigationLink {
    public static var root: Self {
        return .level(id: "", text: "")
    }
}

// MARK: Extension

extension NavigationLink {
    /// - Returns: An appropriate systemImage name
    public var systemImage: String {
        switch self.id.prefix(2) {
            case "AM": return "briefcase"
            case "BE": return "person.3"
            case "BO": return "building.2"
            case "EN": return "bolt"
            case "FM": return "chart.bar.xaxis"
            case "HA": return "cart"
            case "HE": return "house"
            case "HS": return "cross"
            case "JO": return "leaf"
            case "KU": return "paintpalette"
            case "LE": return "umbrella"
            case "ME": return "megaphone"
            case "MI": return "leaf.arrow.triangle.circlepath"
            case "NR": return "sum"
            case "NV": return "case"
            case "OE": return "building.columns"
            case "PR": return "creditcard"
            case "SO": return "lifepreserver"
            case "TK": return "tram"
            case "UF": return "graduationcap"
            default:
                switch self {
                    case .table: return "squareshape.split.2x2.dotted"
                    case .level: return "list.bullet.indent"
                }
        }
    }
    
    private func makePath(_ components: [String]) -> String {
        guard let current = components.last, current.count > 0 else {
            return components.dropLast().reversed().joined(separator: "/")
        }
        return makePath(components + [estimatePrevious(current)])
    }
    
    private func estimatePrevious(_ code: String) -> String {
        let newValue: Substring
        switch code.count {
            case 6: newValue = code.prefix(2)
            case 7: newValue = code.prefix(6)
            case 9: newValue = code.prefix(6) + code.suffix(1)
            default:
                newValue = Substring("")
        }
        return String(newValue)
    }
    
    var path: String {
        return makePath([id])
    }
}
