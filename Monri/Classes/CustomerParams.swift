//
//  CustomerParams.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class CustomerParams {

    public let customerUuid: String?
    public let email: String?
    public let fullName: String?
    public let address: String?
    public let city: String?
    public let zip: String?
    public let phone: String?
    public let country: String?

    public init(customerUuid: String? = nil, email: String?, fullName: String?, address: String?, city: String?, zip: String?, phone: String?, country: String?) {
        self.customerUuid = customerUuid
        self.email = email
        self.fullName = fullName
        self.address = address
        self.city = city
        self.zip = zip
        self.phone = phone
        self.country = country
    }
}
