//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class PaymentResult {
    //("status")
    let status: String

    //("currency")
    let currency: String

    //("amount")
    let amount: Int

    //("order_number")
    let orderNumber: String

    //("pan_token")
    let panToken: String?

    //("created_at")
    let createdAt: String

    //("transaction_type")
    let transactionType: String

    //("payment_method")
    let paymentMethod: SavedPaymentMethod?

    //("errors")
    let errors: [String]

    init(status: String, currency: String, amount: Int, orderNumber: String, panToken: String?, createdAt: String, transactionType: String, paymentMethod: SavedPaymentMethod?, errors: [String]) {
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

    static func fromJson(_ json: Dictionary<String, Any>?) -> PaymentResult? {

        guard let json = json else {
            return nil
        }

        guard let status = json["status"] as? String else {
            return nil
        }

        guard let currency = json["currency"] as? String else {
            return nil
        }

        guard let orderNumber = json["order_number"] as? String else {
            return nil
        }

        guard let createdAt = json["created_at"] as? String else {
            return nil
        }

        guard let transactionType = json["transaction_type"] as? String else {
            return nil
        }

        guard let errors = json["errors"] as? [String] else {
            return nil
        }

        var paymentMethod: SavedPaymentMethod? = nil
        if let pm = json["payment_method"] as? Dictionary<String, String> {
            paymentMethod = SavedCardPaymentMethod.fromJson(pm)
        }

        let panToken = json["pan_token"] as? String

        guard let amount = json["amount"] as? Int else {
            return nil
        }

        return PaymentResult(
                status: status,
                currency: currency,
                amount: amount,
                orderNumber: orderNumber,
                panToken: panToken,
                createdAt: createdAt,
                transactionType: transactionType,
                paymentMethod: paymentMethod,
                errors: errors
        )
    }
}
