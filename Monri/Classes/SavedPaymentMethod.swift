//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public protocol SavedPaymentMethod {
    var type: String { get }
    var data: Dictionary<String, String>{ get }
}

extension SavedPaymentMethod {
    public func toJSON() -> Dictionary<String, Any> {
        return [
            "type": type,
            "data": data
        ]
    }
}
