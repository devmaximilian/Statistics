//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-03.
//

import Foundation
import Combine

extension Statistics {
    public final class Client {
        private let configuration: Configuration
        private let network: URLSession
        
        public init(configuration: Configuration, network: URLSession = .shared) {
            self.configuration = configuration
            self.network = network
        }
    }
}

// MARK: Request
extension Statistics.Client {
    typealias Response = (data: Data, response: URLResponse)
    
    private func request(method: String = "GET", path: String, data: Data? = nil, headers: [String: String] = [:], queryParameters: [String: CustomStringConvertible?] = [:]) -> AnyPublisher<Response, Error> {
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
        
        return self.network.dataTaskPublisher(
            for: request
        )
        .tryMap { (data: Data, response: URLResponse) -> Response in
            guard let response = response as? HTTPURLResponse else {
                throw StatisticsError.networkError(
                    URLError(.unknown)
                )
            }
            guard 200...299 ~= response.statusCode else {
                throw StatisticsError.networkError(
                    URLError(
                        URLError.Code(rawValue: response.statusCode)
                    )
                )
            }
            return (data, response)
        }
        .eraseToAnyPublisher()
    }
}

// MARK: Convenience methods
extension Statistics.Client {
    internal func get(_ path: String, queryParameters: [String: CustomStringConvertible?] = [:]) -> AnyPublisher<Response, Error> {
        return self.request(
            method: "GET",
            path: path,
            queryParameters: queryParameters
        )
    }
    
    internal func patch(_ path: String, data: Data? = nil) -> AnyPublisher<Response, Error> {
        return self.request(
            method: "PATCH",
            path: path,
            data: data
        )
    }
    
    internal func post(_ path: String, data: Data? = nil) -> AnyPublisher<Response, Error> {
        return self.request(
            method: "POST",
            path: path,
            data: data
        )
    }
    
    internal func put(_ path: String, data: Data? = nil) -> AnyPublisher<Response, Error> {
        return self.request(
            method: "PUT",
            path: path,
            data: data
        )
    }
    
    internal func delete(_ path: String, data: Data? = nil) -> AnyPublisher<Response, Error> {
        return self.request(
            method: "DELETE",
            path: path,
            data: data
        )
    }
}
