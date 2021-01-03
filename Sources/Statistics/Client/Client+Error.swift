import Foundation

public enum StatisticsClientError: Error {
    case networkError(URLError)
    case erased(Error)
}
