//
//  CustomerUpdateRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 28. 12. 2022..
//

import Foundation

public class UpdateCustomerParams {
    public let customerData: CustomerData
    public let customerUuid: String
    public let accessToken: String
    
    public init(customerData: CustomerData, customerUuid: String, accessToken: String) {
        self.customerData = customerData
        self.customerUuid = customerUuid
        self.accessToken = accessToken
    }
}
