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

import Foundation
import Combine

/// A publisher that publishes metadata for a table.
///
/// Example usage:
///
///     let client = Statistics.defaultClient
///
///     // Get metadata for a table.
///     client.tableDescriptorPublisher(for: "BE0101A", subject: "BefolkningNy")
///         .assertNoFailure()
///         .sink { tableDescriptor in {
///             // Use table descriptor.
///         }
///
public struct TableDescriptorPublisher: Publisher {
    public typealias Output = TableDescriptor
    public typealias Failure = Error
    
    typealias Upstream = AnyPublisher<(data: Data, response: URLResponse), Error>
    
    let client: Client
    var request: URLRequest

    init(client: Client, request: URLRequest) {
        self.client = client
        self.request = request
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Inner(subscriber: subscriber)
        subscription.configure(
            with: client,
            request: request
        )
        subscriber.receive(subscription: subscription)
    }
}

// MARK: Subscription

extension TableDescriptorPublisher {
    fileprivate final class Inner<S: Subscriber>: Subscription, Subscriber where S.Input == Output, S.Failure == Failure {
        typealias Input = Upstream.Output
        
        private var upstreamSubscription: Subscription?
        private var downstreamSubscriber: S?
        
        init(subscriber: S) {
            self.downstreamSubscriber = subscriber
        }
        
        // MARK: Subscription conformance
        
        func request(_ demand: Subscribers.Demand) {
            guard let upstream = self.upstreamSubscription else { return }
            
            upstream.request(demand)
        }
        
        func cancel() {
            self.downstreamSubscriber = nil
            self.upstreamSubscription = nil
        }
        
        // MARK: Subscriber conformance
        
        func receive(subscription: Subscription) {
            self.upstreamSubscription = subscription
        }
        
        func receive(_ input: Upstream.Output) -> Subscribers.Demand {
            guard let downstream = self.downstreamSubscriber else { return .none }
            
            do {
                let decoder = JSONDecoder()
                let output = try decoder.decode(Output.self, from: input.data)
                return downstream.receive(output)
            } catch {
                downstream.receive(completion: .failure(error))
            }
            
            return .none
        }
        
        func receive(completion: Subscribers.Completion<Upstream.Failure>) {
            self.upstreamSubscription = nil
            
            guard let downstream = self.downstreamSubscriber else {
                return
            }
            downstream.receive(completion: completion)
        }
    }
}

// MARK: Extension to configure data task

extension TableDescriptorPublisher.Inner {
    fileprivate func configure(with client: Client, request: URLRequest) {
        client.network.dataTaskPublisher(
            for: request
        )
        .validateResponse()
        .subscribe(self)
    }
}
