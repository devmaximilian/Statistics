//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

extension TableRequest {
    public struct Selection: Encodable {
        let filter: String = "item"
        let values: [String]
        
        init(_ values: [String]) {
            self.values = values
        }
    }
}
