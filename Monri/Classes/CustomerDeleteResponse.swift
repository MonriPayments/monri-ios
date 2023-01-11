//
//  CustomerDeleteResponse.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public typealias CustomerDeleteCallback = (CustomerDeleteResult) -> Void

public enum CustomerDeleteResult {
    case result(CustomerDeleteResponse)
    case error(CustomerApiError)
}

public class CustomerDeleteResponse {
    public let status: String
    public let uuid: String
    public let deleted: Bool

    public init(status: String, uuid: String, deleted: Bool) {
        self.status = status
        self.uuid = uuid
        self.deleted = deleted
    }

    class func fromJson(_ body: [String: Any]?) -> CustomerDeleteResponse? {
        guard let json = body else {
            return nil
        }

        return CustomerDeleteResponse(
                status: json["status"] as? String ?? "",
                uuid: json["uuid"] as? String ?? "",
                deleted: json["deleted"] as? Bool ?? false
        )
    }
}
