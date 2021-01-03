import Foundation
import Combine

extension Statistics {
    public final class Client {
        internal let configuration: Configuration
        internal let network: URLSession
        
        public init(configuration: Configuration, network: URLSession = .shared) {
            self.configuration = configuration
            self.network = network
        }
    }
}
