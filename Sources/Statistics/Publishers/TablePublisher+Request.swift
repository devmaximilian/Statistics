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
    
    public func query(_ queries: TableRequest.Query...) -> TablePublisher {
        var `self` = self
        self.tableRequest.query.append(contentsOf:
            queries
        )
        return self
    }
}