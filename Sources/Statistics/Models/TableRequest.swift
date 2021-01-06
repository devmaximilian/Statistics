import Foundation

struct TableRequest: Encodable {
    var query: [Query]
    let response: [String: String] = ["format": "json"]
}

extension TableRequest {
    static var empty: TableRequest {
        return TableRequest(query: [])
    }
}

// MARK: Query

struct Query: Encodable {
    let code: String
    let selection: Selection
    
    init(code: String, values: [String]) {
        self.code = code
        self.selection = Selection(values: values)
    }
}

// MARK: Selection

struct Selection: Encodable {
    let filter: String = "item"
    let values: [String]
    
    init(values: [String]) {
        self.values = values
    }
}
