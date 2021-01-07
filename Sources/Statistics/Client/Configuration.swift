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

/// Client configuration.
public struct Configuration {
    private let _baseURL: String
    
    let language: Language
    var baseURL: String {
        _baseURL.replacingOccurrences(of: ":language", with: language.value)
    }

    public init(language: Language = .swedish, baseURL: String = "https://api.scb.se/OV0104/v1/doris/:language/ssd/") {
        self.language = language
        self._baseURL = baseURL
    }
}

extension Configuration {
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

extension Configuration {
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
