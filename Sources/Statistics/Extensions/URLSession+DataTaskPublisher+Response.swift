import Combine
import Foundation

extension URLSession.DataTaskPublisher {
    func validateResponse() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
        self.tryMap { (data: Data, response: URLResponse) -> (data: Data, response: URLResponse) in
            guard let response = response as? HTTPURLResponse else {
                throw StatisticsClientError.networkError(
                    URLError(.unknown)
                )
            }
            guard 200...299 ~= response.statusCode else {
                throw StatisticsClientError.networkError(
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
