//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation
import Combine

extension TablePublisher {
    // Get descriptor?
    
    public func configureRequest(_ configure: (TableRequestBuilder) -> Void) -> TablePublisher {
        var `self` = self
        let builder = TableRequestBuilder()
        configure(builder)
        self.request.httpBody = builder.build()
        return self
    }
}
