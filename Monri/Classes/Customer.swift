//
//  CustomerResponse.swift
//  Monri
//
//  Created by Adnan Omerovic on 15. 12. 2022..
//

import Foundation

public typealias CustomerCallback = (CustomerResult) -> Void

public enum CustomerResult {
    case result(Customer)
    case error(CustomerApiError)
}

public class Customer {
    public let status: String?;
    public let uuid: String?;
    public let merchantCustomerUuid: String?;
    public let description: String?;
    public let email: String?;
    public let name: String?;
    public let phone: String?;
    public let metadata: Dictionary<String, String>?;
    public let zipCode: String?;
    public let city: String?;
    public let address: String?;
    public let country: String?;
    public let deleted: String?;
    public let createdAt: String?;
    public let updatedAt: String?;
    public let deletedAt: String?;

    public init(
            status: String?,
            uuid: String?,
            merchantCustomerUuid: String?,
            description: String?,
            email: String?,
            name: String?,
            phone: String?,
            metadata: Dictionary<String, String>?,
            zipCode: String?,
            city: String?,
            address: String?,
            country: String?,
            deleted: String?,
            createdAt: String?,
            updatedAt: String?,
            deletedAt: String?
    ) {
        self.status = status
        self.uuid = uuid
        self.merchantCustomerUuid = merchantCustomerUuid
        self.description = description
        self.email = email
        self.name = name
        self.phone = phone
        self.metadata = metadata
        self.zipCode = zipCode
        self.city = city
        self.address = address
        self.country = country
        self.deleted = deleted
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }

    public static func fromJson(_ json: Dictionary<String, Any>?) -> Customer? {
        guard let json = json else {
            return nil
        }

        return Customer(
                status: json["status"] as? String,
                uuid: json["uuid"] as? String,
                merchantCustomerUuid: json["merchant_customer_id"] as? String,
                description: json["description"] as? String,
                email: json["email"] as? String,
                name: json["name"] as? String,
                phone: json["phone"] as? String,
                metadata: json["metadata"] as? Dictionary<String, String> ?? Dictionary<String, String>(),
                zipCode: json["zip_code"] as? String,
                city: json["city"] as? String,
                address: json["address"] as? String,
                country: json["country"] as? String,
                deleted: json["deleted"] as? String,
                createdAt: json["created_at"] as? String,
                updatedAt: json["updated_at"] as? String,
                deletedAt: json["deleted_at"] as? String
        )
    }
}
