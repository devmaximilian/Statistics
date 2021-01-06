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
import Combine
import Logging

public final class Client {
    let configuration: Configuration
    let network: URLSession
    let logger: Logger
    
    /// Creates a new instance of Client.
    ///
    /// The client is responsible for providing publishers.
    /// - Parameters:
    ///   - configuration: The client configuration to use.
    ///   - network: The URLSession instance to use.
    ///   - logger: An optional logger for logging.
    public init(configuration: Configuration, network: URLSession = .shared, logger: Logger? = nil) {
        self.configuration = configuration
        self.network = network
        self.logger = logger ?? Logger(label: "client")
    }
    
    /// Returns a publisher that wraps a navigation structure request for a navigation link.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter code: The id of a navigation link for which to create a request.
    /// - Returns: A publisher that wraps a navigation structure request for the provided id.
    public func navigationPublisher(for code: String) -> NavigationPublisher {
        self.logger.info("Getting navigation publisher for \(code.count == 0 ? "root" : code).")
        return NavigationPublisher(
            client: self,
            request: get(code)
        )
    }
    
    /// Returns a publisher that wraps a table request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameters:
    ///   - code: The subject area of the subject.
    ///   - subject: The subject for which to create a request.
    /// - Returns: A publisher that wraps a table request for the given subject.
    public func tablePublisher(for code: String, subject: String) -> TablePublisher {
        self.logger.info("Getting table publisher for \(code).")
        return TablePublisher(
            client: self,
            request: post("\(code)/\(subject)")
        )
    }
    
    /// Returns a publisher that wraps a table descriptor request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameters:
    ///   - code: The subject area of the subject.
    ///   - subject: The subject for which to create a request.
    /// - Returns: A publisher that wraps a table descriptor request for the given subject.
    public func tableDescriptorPublisher(for code: String, subject: String) -> TableDescriptorPublisher {
        self.logger.info("Getting table descriptor publisher for \(code).")
        return TableDescriptorPublisher(
            client: self,
            request: get("\(code)/\(subject)")
        )
    }
    
    
    // MARK: Convenience
    
    
    /// Returns a publisher that wraps a navigation structure request for a navigation link.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter code: The id of a navigation link for which to create a request.
    /// - Returns: A publisher that wraps a navigation structure request for the provided id.
    public func navigationPublisher(for code: NavigationLink) -> NavigationPublisher {
        return self.navigationPublisher(for: code.id)
    }
    
    /// Returns a publisher that wraps a table request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameters:
    ///   - code: The subject area of the subject.
    ///   - subject: The subject for which to create a request.
    /// - Returns: A publisher that wraps a table request for the given subject.
    public func tablePublisher(for code: NavigationLink, subject: NavigationLink) -> TablePublisher {
        return self.tablePublisher(for: code.id, subject: subject.id)
    }
    
    /// Returns a publisher that wraps a table descriptor request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameters:
    ///   - code: The subject area of the subject.
    ///   - subject: The subject for which to create a request.
    /// - Returns: A publisher that wraps a table descriptor request for the given subject.
    public func tableDescriptorPublisher(for code: NavigationLink, subject: NavigationLink) -> TableDescriptorPublisher {
        return self.tableDescriptorPublisher(for: code.id, subject: subject.id)
    }
}

// MARK: Requests

extension Client {
    private func request(method: String = "GET", path: String, data: Data? = nil, headers: [String: String] = [:], queryParameters: [String: CustomStringConvertible?] = [:]) -> URLRequest {
        var request = URLRequest(
            url: self.configuration.buildURL(
                for: path,
                with: queryParameters
            )
        )
        headers.forEach { (field: String, value: String) in
            request.addValue(value, forHTTPHeaderField: field)
        }
        request.httpBody = data
        request.httpMethod = method
        return request
    }
    
    func get(_ path: String, queryParameters: [String: CustomStringConvertible?] = [:]) -> URLRequest {
        return self.request(
            method: "GET",
            path: path,
            queryParameters: queryParameters
        )
    }
    
    func post(_ path: String, data: Data? = nil) -> URLRequest {
        return self.request(
            method: "POST",
            path: path,
            data: data
        )
    }
}
