//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log

public class PaymentResult {

    private static let REQUIRED_STRING_FIELDS = ["status",
                                                 "currency",
                                                 "order_number",
                                                 "created_at",
                                                 "transaction_type"
    ]

    static let logger: MonriLogger = MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "PaymentResult"))

    //("status")
    public let status: String

    //("currency")
    public let currency: String?

    //("amount")
    public let amount: Int?

    //("order_number")
    public let orderNumber: String?

    //("pan_token")
    public let panToken: String?

    //("created_at")
    public let createdAt: String?

    //("transaction_type")
    public let transactionType: String?

    //("payment_method")
    public let paymentMethod: SavedPaymentMethod?

    //("errors")
    public let errors: [String]

    init(status: String, currency: String?, amount: Int?, orderNumber: String?, panToken: String?, createdAt: String?, transactionType: String?, paymentMethod: SavedPaymentMethod?, errors: [String]) {
        self.status = status
        self.currency = currency
        self.amount = amount
        self.orderNumber = orderNumber
        self.panToken = panToken
        self.createdAt = createdAt
        self.transactionType = transactionType
        self.paymentMethod = paymentMethod
        self.errors = errors
    }
    
    public func toJSON() -> Dictionary<String, Any?> {
        return [
            "status": status,
            "currency": currency,
            "amount": amount,
            "order_number": orderNumber,
            "pan_token": panToken,
            "created_at": createdAt,
            "transaction_type": transactionType,
            "payment_method": paymentMethod?.toJSON(),
            "errors": errors
        ]
    }

    static func fromJson(_ json: Dictionary<String, Any>?) -> PaymentResult? {

        guard let json = json else {
            return nil
        }

        let missingKey = PaymentResult.REQUIRED_STRING_FIELDS.first { s in
            (json[s] as? String) == nil
        }

        if missingKey != nil {
            logger.warn("Missing key \(missingKey!) in fromJson, got json = \(json)")
            return nil
        }

        var errors: [String] = []

        if let value = json["errors"] as? [String] {
            errors = value
        }

        var paymentMethod: SavedPaymentMethod? = nil
        if let pm = json["payment_method"] as? Dictionary<String, Any> {
            paymentMethod = SavedCardPaymentMethod.fromJson(pm)
        }

        let panToken = json["pan_token"] as? String

        guard let amount = json["amount"] as? Int else {
            return nil
        }

        return PaymentResult(
                status: json["status"] as! String,
                currency: json["currency"] as? String,
                amount: amount,
                orderNumber: json["order_number"] as? String,
                panToken: panToken,
                createdAt: json["created_at"] as? String,
                transactionType: json["transaction_type"] as? String,
                paymentMethod: paymentMethod,
                errors: errors
        )
    }
}
