import XCTest
import Combine
@testable import Statistics

final class NavigationPublisherTests: XCTestCase {
    private let client = Statistics.defaultClient
    private var cancellables: Set<AnyCancellable> = .init()
    
    func testPublish() {
        let condition = expectation(description: "NavigationPublisher should publish values if it has not been cancelled.")
        
        var published: Bool = false
        self.client.navigationPublisher(for: .root)
            .sink(receiveCompletion: { (completion) in
                XCTAssert(published, "Should publish values!")
                condition.fulfill()
            }, receiveValue: { _ in
                published = true
            })
            .store(in: &self.cancellables)

        wait(for: [condition], timeout: 30)
    }
    
    func testCancel() {
        let condition = expectation(description: "NavigationPublisher should not publish values if it has been cancelled.")
        
        let publisher = self.client.navigationPublisher(for: .root)
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
}
