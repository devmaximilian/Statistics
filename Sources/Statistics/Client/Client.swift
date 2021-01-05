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
    
    public func navigationPublisher(for link: NavigationLink) -> NavigationPublisher {
        return NavigationPublisher(
            client: self,
            request: get(link.id)
        )
    }
    
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
    
    public func tablePublisher(for link: NavigationLink) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: post(link.id)
        )
    }
    
    public func tablePublisher(for code: String, method: String) -> TablePublisher {
        return TablePublisher(
            client: self,
            request: post("\(code)/\(method)")
        )
    }
}
