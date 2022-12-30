//
//  CustomerCreateRequest.swift
//  Monri
//
//  Created by Adnan Omerovic on 15. 12. 2022..
//

import Foundation

public class CustomerRequestBody {
    public let merchantCustomerId: String;
    public let description: String;
    public let email: String;
    public let name: String;
    public let phone: String;
    public let metadata: Dictionary<String, String>;
    public let zipCode: String;
    public let city: String;
    public let address: String;
    public let country: String;

    public init(
            merchantCustomerId: String?,
            description: String?,
            email: String?,
            name: String?,
            phone: String?,
            metadata: Dictionary<String, String>?,
            zipCode: String?,
            city: String?,
            address: String?,
            country: String?
    ) {
        self.merchantCustomerId = merchantCustomerId ?? ""
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

    func toJSON() -> Dictionary<String, Any> {
        [
            "merchant_customer_id": merchantCustomerId,
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
