import Foundation
import Combine
import Logging

public final class StatisticsClient {
    internal let configuration: Configuration
    internal let network: URLSession
    internal let logger: Logger
    
    /// Creates a new instance of StatisticsClient.
    ///
    /// The client is responsible for providing publishers.
    /// - Parameter configuration: The client configuration to use.
    /// - Parameter network: The URLSession instance to use.
    /// - Parameter logger: An optional logger for logging. A default will be used if not provided.
    public init(configuration: Configuration, network: URLSession = .shared, logger: Logger? = nil) {
        self.configuration = configuration
        self.network = network
        self.logger = logger ?? Logger(label: "client")
    }
    
    /// Returns a publisher that wraps a navigation structure request for a given navigation link.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter link: The navigation link for which to create a request.
    /// - Returns: A publisher that wraps a navigation structure request for the navigation link.
    public func navigationPublisher(for link: NavigationLink) -> NavigationPublisher {
        return NavigationPublisher(
            client: self,
            request: get(link.id)
        )
    }
    
    /// Returns a publisher that wraps a navigation structure request for a given navigation link.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter code: The id of a NavigationLink for which to create a request.
    /// - Returns: A publisher that wraps a navigation structure request for the NavigationLink id.
    public func navigationPublisher(for code: String) -> NavigationPublisher {
        return NavigationPublisher(
            client: self,
            request: get(code)
        )
    }
    
    /// Returns a publisher that wraps a table descriptor request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter link: The navigation link indicating the subject area of the subject.
    /// - Parameter subject: The navigation link specifying the subject for which to create a request.
    /// - Returns: A publisher that wraps a table descriptor request for the given subject.
    public func tableDescriptorPublisher(for link: NavigationLink, subject: NavigationLink) -> TableDescriptorPublisher {
        return TableDescriptorPublisher(
            client: self,
            request: get("\(link.id)/\(subject.id)")
        )
    }
    
    /// Returns a publisher that wraps a table descriptor request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter link: The subject area of the subject.
    /// - Parameter subject: The subject for which to create a request.
    /// - Returns: A publisher that wraps a table descriptor request for the given subject.
    public func tableDescriptorPublisher(for code: String, subject: String) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: get("\(code)/\(subject)")
        )
    }
    
    /// Returns a publisher that wraps a table descriptor request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter link: The navigation link indicating the subject area of the subject.
    /// - Parameter subject: The navigation link specifying the subject for which to create a request.
    /// - Returns: A publisher that wraps a table descriptor request for the given subject.
    public func tablePublisher(for link: NavigationLink, subject: NavigationLink) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: post("\(link.id)/\(subject.id)")
        )
    }
    
    /// Returns a publisher that wraps a table request for a given subject.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter link: The subject area of the subject.
    /// - Parameter subject: The subject for which to create a request.
    /// - Returns: A publisher that wraps a table request for the given subject.
    public func tablePublisher(for code: String, subject: String) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: post("\(code)/\(subject)")
        )
    }
}
