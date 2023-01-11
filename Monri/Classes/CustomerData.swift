//
//  CustomerCreateRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 15. 12. 2022..
//

import Foundation

public class CustomerData {
    public var merchantCustomerUuid: String?;
    public var description: String;
    public var email: String;
    public var name: String;
    public var phone: String;
    public var metadata: Dictionary<String, String>;
    public var zipCode: String;
    public var city: String;
    public var address: String;
    public var country: String;

    public init(
            merchantCustomerUuid: String? = nil,
            description: String? = nil,
            email: String? = nil,
            name: String? = nil,
            phone: String? = nil,
            metadata: Dictionary<String, String>? = nil,
            zipCode: String? = nil,
            city: String? = nil,
            address: String? = nil,
            country: String? = nil
    ) {
        self.merchantCustomerUuid = merchantCustomerUuid
        self.description = description ?? ""
        self.email = email ?? ""
        self.name = name ?? ""
        self.phone = phone ?? ""
        self.metadata = metadata ?? Dictionary<String, String>()
        self.zipCode = zipCode ?? ""
        self.city = city ?? ""
        self.address = address ?? ""
        self.country = country ?? ""
    }

    public func setEmail(_ newValue: String) -> CustomerData {
        email = newValue
        return self
    }
    
    public func setName(_ newValue: String) -> CustomerData {
        name = newValue
        return self
    }

    func toJSON() -> Dictionary<String, Any> {
        [
            "merchant_customer_id": merchantCustomerUuid,
            "description": description,
            "email": email,
            "name": name,
            "phone": phone,
            "metadata": metadata,
            "zip_code": zipCode,
            "city": city,
            "address": address,
            "country": country,
        ]
    }
}
