//
//  CustomerCreateRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 28. 12. 2022..
//

import Foundation

public class CustomerCreateRequest {
    public let accessToken: String;
    public let customerRequestBody: CustomerRequestBody;

    public init(accessToken: String, customerRequestBody: CustomerRequestBody) {
        self.accessToken = accessToken
        self.customerRequestBody = customerRequestBody
    }

}