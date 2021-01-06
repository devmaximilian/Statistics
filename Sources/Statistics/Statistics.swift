public struct Statistics {
    private static var _defaultClient: Client? = nil
    private static var _defaultConfiguration: Configuration? = nil
    
    /// The default client configuration.
    ///
    /// - Note: Initialized upon being accessed.
    public static var defaultConfiguration: Configuration {
        get {
            guard let configuration = _defaultConfiguration else {
                _defaultConfiguration = Configuration(language: .dynamic)
                return self.defaultConfiguration
            }
            return configuration
        }
        set {
            _defaultConfiguration = newValue
        }
    }
    
    /// The default client.
    ///
    /// - Note: Initialized upon being accessed.
    public static var defaultClient: Client {
        get {
            guard let client = _defaultClient else {
                _defaultClient = Client(configuration: defaultConfiguration)
                return self.defaultClient
            }
            return client
        }
        set {
            _defaultClient = newValue
        }
    }
}

/// Typealias to disambiguate `Client`
public typealias StatisticsClient = Client

/// Typealias to disambiguate `Configuration`
public typealias StatisticsClientConfiguration = Configuration
