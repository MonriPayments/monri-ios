//
//  CustomerParams.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class CustomerParams {

    let email: String?
    let fullName: String?
    let address: String?
    let city: String?
    let zip: String?
    let phone: String?
    let country: String?

    public init(email: String?, fullName: String?, address: String?, city: String?, zip: String?, phone: String?, country: String?) {
        self.email = email
        self.fullName = fullName
        self.address = address
        self.city = city
        self.zip = zip
        self.phone = phone
        self.country = country
    }
}
