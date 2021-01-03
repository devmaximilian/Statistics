import Foundation

public enum StatisticsError: Error {
    case networkError(URLError)
    case erased(Error)
}
