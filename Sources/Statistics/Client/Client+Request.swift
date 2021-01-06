import Foundation
import Combine

extension StatisticsClient {
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
}

// MARK: Convenience

extension StatisticsClient {
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
