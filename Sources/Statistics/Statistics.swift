public struct Statistics {
    var text = "Hello, World!"
    
    private static var _defaultClient: StatisticsClient? = nil
    private static var _defaultConfiguration: StatisticsClient.Configuration? = nil
    
    public static var defaultConfiguration: StatisticsClient.Configuration {
        get {
            guard let configuration = _defaultConfiguration else {
                _defaultConfiguration = StatisticsClient.Configuration(language: .detect)
                return self.defaultConfiguration
            }
            return configuration
        }
        set {
            _defaultConfiguration = newValue
        }
    }
    
    public static var defaultClient: StatisticsClient {
        get {
            guard let client = _defaultClient else {
                _defaultClient = StatisticsClient(configuration: defaultConfiguration)
                return self.defaultClient
            }
            return client
        }
        set {
            _defaultClient = newValue
        }
    }
}
