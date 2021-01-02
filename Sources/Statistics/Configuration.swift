import Foundation

extension Statistics {
    public struct Configuration {
        private let language: Language
        internal var baseURL: String {
            "https://api.scb.se/OV0104/v1/doris/\(language.rawValue)/ssd/"
        }

        public init(language: Language = .swedish) {
            self.language = language
        }
    }
}

extension Statistics.Configuration {
    public enum Language: String {
        case swedish
        case english

        public static var detect: Language {
            return Locale.current.languageCode == "en" ? .english : .swedish
        }
    }
}
