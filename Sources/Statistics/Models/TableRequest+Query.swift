//
//  File.swift
//  
//
//  Created by Maximilian Wendel on 2021-01-04.
//

import Foundation

extension TableRequest {
    public struct Query: Encodable {
        let code: String
        let selection: Selection
    }
}
