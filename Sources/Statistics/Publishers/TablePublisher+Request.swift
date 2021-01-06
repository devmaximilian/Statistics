import Foundation
import Combine

extension TablePublisher {
    /// Configure the table publishers request.
    ///
    /// The publisher publishes a table when the request completes, or terminates if the task fails.
    /// - Parameter configure: A closure that takes a table request builder and descriptor as parameters, enabling request modifications.
    /// - Note: Do not specify the descriptor property if it will be unused, as this greatly increases the request cost.
    /// - Returns: A publisher that wraps a table descriptor publisher and configuration closure that are used to modify the table publishers request.
    public func configureRequest(_ configure: @escaping (TableRequestBuilder, TableDescriptor) -> Void) -> AnyPublisher<Table, Error> {
        guard let subject = self.request.url?.lastPathComponent,
           let code = self.request.url?.deletingLastPathComponent().lastPathComponent else {
            return Fail(outputType: Output.self, failure: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        return self.client.tableDescriptorPublisher(for: code, subject: subject)
            .flatMap { descriptor -> TablePublisher in
                var `self` = self
                let builder = TableRequestBuilder()
                configure(builder, descriptor)
                self.request.httpBody = builder.build()
                return self
            }.eraseToAnyPublisher()
    }
    
    /// Configure the table publishers request.
    ///
    /// The publisher publishes a table when the request completes, or terminates if the task fails.
    /// - Parameter configure: A closure that takes a table request builder as a parameter, enabling request modifications.
    /// - Returns: A publisher that wraps a table descriptor publisher and configuration closure that are used to modify the table publishers request.
    public func configureRequest(_ configure: (TableRequestBuilder) -> Void) -> TablePublisher {
        var `self` = self
        let builder = TableRequestBuilder()
        configure(builder)
        self.request.httpBody = builder.build()
        return self
    }
}
