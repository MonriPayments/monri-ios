//
//  CustomerRetrieveRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public class CustomerRetrieveRequest {
    public let accessToken: String
    public let customerUuid: String

    public init(accessToken: String, customerUuid: String) {
        self.accessToken = accessToken
        self.customerUuid = customerUuid
    }
}
