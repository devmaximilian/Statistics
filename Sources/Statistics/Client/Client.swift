import Foundation
import Combine
import Logging

public final class StatisticsClient {
    internal let configuration: Configuration
    internal let network: URLSession
    internal let logger: Logger
    
    public init(configuration: Configuration, network: URLSession = .shared, logger: Logger? = nil) {
        self.configuration = configuration
        self.network = network
        self.logger = logger ?? Logger(label: "client")
    }
    
    /// Returns a publisher that wraps a navigation structure request for a given navigation link.
    ///
    /// The publisher publishes data when the request completes, or terminates if the task fails.
    /// - Parameter link: The NavigationLink for which to create a request.
    /// - Returns: A publisher that wraps a navigation structure request for the NavigationLink.
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
    
    public func tableDescriptorPublisher(for link: NavigationLink, method: NavigationLink) -> TableDescriptorPublisher {
        return TableDescriptorPublisher(
            client: self,
            request: get("\(link.id)/\(method.id)")
        )
    }
    
    public func tableDescriptorPublisher(for code: String, method: String) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: get("\(code)/\(method)")
        )
    }
    
    public func tablePublisher(for link: NavigationLink, method: NavigationLink) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: post("\(link.id)/\(method.id)")
        )
    }
    
    public func tablePublisher(for code: String, method: String) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: post("\(code)/\(method)")
        )
    }
}
