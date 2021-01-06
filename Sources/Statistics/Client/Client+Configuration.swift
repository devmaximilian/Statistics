import Foundation

extension StatisticsClient {
    /// Client configuration.
    public struct Configuration {
        let language: Language
        var baseURL: String {
            "https://api.scb.se/OV0104/v1/doris/\(language.value)/ssd/"
        }

        public init(language: Language = .swedish) {
            self.language = language
        }
    }
}

extension StatisticsClient.Configuration {
    /// Used to determine endpoint.
    public enum Language {
        case swedish
        case english
        case dynamic
        
        var value: String {
            switch self {
                case .swedish: return "sv"
                case .english: return "en"
                case .dynamic: return current.value
            }
        }

        private var current: Language {
            return Locale.current.languageCode == "en" ? .english : .swedish
        }
    }
}

// MARK: Build URL
extension StatisticsClient.Configuration {
    func buildURL(for path: String, with queryParameters: [String: CustomStringConvertible?]) -> URL {
        guard path.hasPrefix("/") == false else {
            return buildURL(for: String(path.suffix(path.count-1)), with: queryParameters)
        }
        guard var components = URLComponents(string: self.baseURL + path) else {
            fatalError()
        }
        if queryParameters.count > 0, components.queryItems == nil {
            components.queryItems = []
        }
        queryParameters.forEach { (name: String, value: CustomStringConvertible?) in
            let item = URLQueryItem(
                name: name,
                value: value?.description
            )
            components.queryItems?.append(item)
        }
        return components.url!
    }
}
