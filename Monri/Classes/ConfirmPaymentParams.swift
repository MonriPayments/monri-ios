//
//  ConfirmPaymentParams.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class ConfirmPaymentParams {
    public let paymentId: String
    public let paymentMethod: PaymentMethodParams
    public let transaction: TransactionParams

    public init(paymentId: String, paymentMethod: PaymentMethodParams, transaction: TransactionParams) {
        self.paymentId = paymentId
        self.paymentMethod = paymentMethod
        self.transaction = transaction
    }

    func toJSON() -> Dictionary<String, Any> {
        [
            "payment_method": paymentMethod.toJSON(),
            "transaction": transaction.toJSON()
        ]
    }

}
