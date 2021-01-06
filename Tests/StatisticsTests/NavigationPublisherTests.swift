// MIT License
//
// Copyright (c) 2021 Maximilian Wendel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

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
