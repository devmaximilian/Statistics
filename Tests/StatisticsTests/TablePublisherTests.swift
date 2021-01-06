import XCTest
import Combine
@testable import Statistics

final class TablePublisherTests: XCTestCase {
    private let client = Statistics.defaultClient
    private var cancellables: Set<AnyCancellable> = .init()
    
    func testPublish() {
        let condition = expectation(description: "TablePublisher should publish values if it has not been cancelled.")
        
        var published: Bool = false
        self.client.tablePublisher(for: "BE0101A", subject: "BefolkningNy")
            .configureRequest { builder in
                builder.select("BE0101N1")
                    .filter("Region", by: "00")
            }
            .sink(receiveCompletion: { (completion) in
                XCTAssert(published, "Should publish values!")
                condition.fulfill()
            }, receiveValue: { table in
                XCTAssert(table.columns.contains(where: { $0.code == "BE0101N1" }))
                published = true
            })
            .store(in: &self.cancellables)

        wait(for: [condition], timeout: 30)
    }
    
    func testPublishWithRequestConfiguration() {
        let condition = expectation(description: "TablePublisher should publish values if it has not been cancelled.")
        
        var published: Bool = false
        self.client.tablePublisher(for: "BE0101A", subject: "BefolkningNy")
            .configureRequest { builder in
                builder.select("BE0101N1")
                    .filter("Region", by: "00")
            }
            .sink(receiveCompletion: { (completion) in
                XCTAssert(published, "Should publish values!")
                condition.fulfill()
            }, receiveValue: { table in
                XCTAssert(table.columns.contains(where: { $0.code == "BE0101N1" }))
                published = true
            })
            .store(in: &self.cancellables)

        wait(for: [condition], timeout: 30)
    }
    
    func testPublishWithRequestConfigurationAndDescriptor() {
        let condition = expectation(description: "TablePublisher should publish values if it has not been cancelled.")
        
        var published: Bool = false
        self.client.tablePublisher(for: "BE0101A", subject: "BefolkningNy")
            .configureRequest { (builder, descriptor) in
                guard let variable = descriptor.variables.first else {
                    XCTFail("No variables present for descriptor.")
                    return
                }
                builder.select("BE0101N1")
                    .filter(variable.code, by: variable.values.map(\.value))
            }
            .sink(receiveCompletion: { (completion) in
                XCTAssert(published, "Should publish values!")
                condition.fulfill()
            }, receiveValue: { table in
                XCTAssert(table.columns.contains(where: { $0.code == "BE0101N1" }))
                published = true
            })
            .store(in: &self.cancellables)

        wait(for: [condition], timeout: 30)
    }
    
    func testCancel() {
        let condition = expectation(description: "TablePublisher should not publish values if it has been cancelled.")
        
        let publisher = self.client.tablePublisher(for: "BE0101A", subject: "BefolkningNy")
            .handleEvents(
                receiveSubscription: nil,
                receiveOutput: { _ in
                    XCTFail("Should not publish values if cancelled!")
                },
                receiveCompletion: { _ in
                    XCTFail("Should not complete if cancelled!")
                },
                receiveCancel: {
                    condition.fulfill()
                },
                receiveRequest: nil
            )
            
        let task = publisher.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
        task.cancel()
        
        wait(for: [condition], timeout: 30)
    }

    static var allTests = [
        ("testCancel", testCancel),
    ]
}
