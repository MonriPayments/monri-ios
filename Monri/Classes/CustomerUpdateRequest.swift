//
//  CustomerUpdateRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 28. 12. 2022..
//

import Foundation

public class CustomerUpdateRequest {
    public let customerBodyRequest: CustomerRequestBody
    public let customerUuid: String
    public let accessToken: String
    
    public init(customerRequestBody: CustomerRequestBody, customerUuid: String, accessToken: String) {
        self.customerBodyRequest = customerRequestBody
        self.customerUuid = customerUuid
        self.accessToken = accessToken
    }
}
