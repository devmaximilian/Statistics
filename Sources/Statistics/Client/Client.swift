//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-03.
//

import Foundation

extension Statistics {
    public final class Client {
        private let configuration: Configuration
        private let network: Networking
        
        public init(configuration: Configuration, network: Networking = URLSession.shared) {
            self.configuration = configuration
            self.network = network
        }
    }
}
