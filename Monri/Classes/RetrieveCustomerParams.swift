//
//  CustomerRetrieveRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public class RetrieveCustomerParams {
    public let accessToken: String
    public let customerUuid: String

    public init(accessToken: String, customerUuid: String) {
        self.accessToken = accessToken
        self.customerUuid = customerUuid
    }
}
