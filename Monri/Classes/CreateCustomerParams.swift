//
//  CustomerCreateRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 28. 12. 2022..
//

import Foundation

public class CreateCustomerParams {
    public let accessToken: String;
    public let customerData: CustomerData;

    public init(accessToken: String, customerData: CustomerData) {
        self.accessToken = accessToken
        self.customerData = customerData
    }

}