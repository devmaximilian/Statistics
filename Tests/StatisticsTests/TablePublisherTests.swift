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
                guard let filter = descriptor.filters.first,
                      let column = descriptor.columns.first,
                      let time = descriptor.series.first else {
                    XCTFail("No variables present for descriptor.")
                    return
                }
                builder.select(column)
                    .filter(filter, by: filter.values.map(\.value))
                    .between("2000", "2005", using: time)
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
}
