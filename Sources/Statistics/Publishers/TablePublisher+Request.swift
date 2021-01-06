import Foundation
import Combine

extension TablePublisher {
    // Get descriptor?
    
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
    
    public func configureRequest(_ configure: (TableRequestBuilder) -> Void) -> TablePublisher {
        var `self` = self
        let builder = TableRequestBuilder()
        configure(builder)
        self.request.httpBody = builder.build()
        return self
    }
}
