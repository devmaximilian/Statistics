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

public struct Statistics {
    private static var _defaultClient: Client? = nil
    private static var _defaultConfiguration: Configuration? = nil
    
    /// The default client configuration.
    ///
    /// - Note: Initialized upon being accessed.
    public static var defaultConfiguration: Configuration {
        get {
            guard let configuration = _defaultConfiguration else {
                _defaultConfiguration = Configuration(language: .dynamic)
                return self.defaultConfiguration
            }
            return configuration
        }
        set {
            _defaultConfiguration = newValue
        }
    }
    
    /// The default client.
    ///
    /// - Note: Initialized upon being accessed.
    public static var defaultClient: Client {
        get {
            guard let client = _defaultClient else {
                _defaultClient = Client(configuration: defaultConfiguration)
                return self.defaultClient
            }
            return client
        }
        set {
            _defaultClient = newValue
        }
    }
}

/// Typealias to disambiguate `Client`
public typealias StatisticsClient = Client

/// Typealias to disambiguate `Configuration`
public typealias StatisticsClientConfiguration = Configuration
