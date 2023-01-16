//
//  CustomerPaymentMethod.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public class CustomerPaymentMethod {
    public let status: String?
    public let id: String?
    public let maskedPan: String?
    public let expirationDate: String?
    public let keepUntil: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let customerUuid: String?
    public let token: String?
    public let expired: Bool?

    public init(
            status: String?,
            id: String?,
            maskedPan: String?,
            expirationDate: String?,
            keepUntil: String?,
            createdAt: String?,
            updatedAt: String?,
            customerUuid: String?,
            token: String?,
            expired: Bool?
    ) {
        self.status = status
        self.id = id
        self.maskedPan = maskedPan
        self.expirationDate = expirationDate
        self.keepUntil = keepUntil
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.customerUuid = customerUuid
        self.token = token
        self.expired = expired
    }

    class func fromJson(_ paymentMethod: Dictionary<String, Any>?) -> CustomerPaymentMethod? {
        guard let jsonPaymentMethod = paymentMethod else {
            return nil
        }

        return CustomerPaymentMethod(
                status: (jsonPaymentMethod["status"] as? String),
                id: (jsonPaymentMethod["id"] as? String),
                maskedPan: (jsonPaymentMethod["masked_pan"] as? String),
                expirationDate: (jsonPaymentMethod["expiration_date"] as? String),
                keepUntil: (jsonPaymentMethod["keep_until"] as? String),
                createdAt: (jsonPaymentMethod["created_at"] as? String),
                updatedAt: (jsonPaymentMethod["updated_at"] as? String),
                customerUuid: (jsonPaymentMethod["customer_uuid"] as? String),
                token: (jsonPaymentMethod["token"] as? String),
                expired: (jsonPaymentMethod["expired"] as? Bool)
        )
    }

}
