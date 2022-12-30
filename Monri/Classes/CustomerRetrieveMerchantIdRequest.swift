//
//  CustomerRetrieveMerchantIdRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public class CustomerRetrieveMerchantIdRequest {
    public let accessToken: String
    public let merchantCustomerUuid: String

    public init(accessToken: String, merchantCustomerUuid: String) {
        self.accessToken = accessToken
        self.merchantCustomerUuid = merchantCustomerUuid
    }
}
