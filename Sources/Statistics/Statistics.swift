public struct Statistics {
    var text = "Hello, World!"
    
    private static var _defaultClient: Client? = nil
    private static var _defaultConfiguration: Configuration? = nil
    
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
