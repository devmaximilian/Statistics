import Foundation
import Combine
import Logging

public final class StatisticsClient {
    let configuration: Configuration
    let network: URLSession
    let logger: Logger
    
    /// Creates a new instance of StatisticsClient.
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
        self.logger.info("Getting navigation publisher for \(code).")
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
