//
//  CustomerDeleteResponse.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public typealias DeleteCustomerCallback = (DeleteCustomerResult) -> Void

public enum DeleteCustomerResult {
    case result(DeleteCustomerResponse)
    case error(CustomerApiError)
}

public class DeleteCustomerResponse {
    public let status: String
    public let uuid: String
    public let deleted: Bool

    public init(status: String, uuid: String, deleted: Bool) {
        self.status = status
        self.uuid = uuid
        self.deleted = deleted
    }

    class func fromJson(_ body: [String: Any]?) -> DeleteCustomerResponse? {
        guard let json = body else {
            return nil
        }

        return DeleteCustomerResponse(
                status: json["status"] as? String ?? "",
                uuid: json["uuid"] as? String ?? "",
                deleted: json["deleted"] as? Bool ?? false
        )
    }
}
