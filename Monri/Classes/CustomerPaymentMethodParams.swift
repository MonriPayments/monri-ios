//
//  CustomerPaymentMethodRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public class CustomerPaymentMethodParams {
    public let customerUuid: String
    public let limit: UInt32
    public let offset: UInt32
    public let accessToken: String

    public init(customerUuid: String, limit: UInt32, offset: UInt32, accessToken: String) {
        self.customerUuid = customerUuid
        self.limit = limit
        self.offset = offset
        self.accessToken = accessToken
    }
}
