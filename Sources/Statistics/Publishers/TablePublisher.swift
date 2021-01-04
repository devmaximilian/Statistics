import Foundation
import Combine

/// A publisher that retrieves a table.
///
///     Statistics.defaultClient.tablePublisher(for: link)
///         .configureTableRequest { (descriptor, requestBuilder) -> Void in
///             requestBuilder.select("ContentCode", value: "BE0101N1")
///         }
///
public struct TablePublisher: Publisher {
    public typealias Output = [NavigationLink]
    public typealias Failure = Error
    
    // TODO: This needs to be a wrapped request as the request
    //       needs to be modified before being sent (table request).
    typealias Upstream = AnyPublisher<StatisticsClient.Response, Error>
    
    private let upstream: Upstream
    var tableRequest: TableRequest

    init(with upstream: Upstream, tableRequest: TableRequest = .empty) {
        self.upstream = upstream
        self.tableRequest = tableRequest
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        let subscription = Inner(subscriber: subscriber)
        upstream.subscribe(subscription)
        subscriber.receive(subscription: subscription)
    }
}

// MARK: Subscription

extension TablePublisher {
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
