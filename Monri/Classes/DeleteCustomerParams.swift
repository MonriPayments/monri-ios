//
//  CustomerDeleteRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public class DeleteCustomerParams {
    public let customerUuid: String
    public let accessToken: String

    public init(customerUuid: String, accessToken: String) {
        self.customerUuid = customerUuid
        self.accessToken = accessToken
    }
}
