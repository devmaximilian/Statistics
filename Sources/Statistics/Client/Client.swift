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
    
    public func tableDescriptorPublisher(for link: NavigationLink) {
        
    }
    
    public func tablePublisher(for link: NavigationLink, tableRequest: TableRequest = .empty) {
        
    }
}
