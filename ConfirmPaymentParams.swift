//
//  ConfirmPaymentParams.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class ConfirmPaymentParams {
    private let paymentId: String
    private let paymentMethod: PaymentMethodParams
    private let transaction: TransactionParams

    public init(paymentId: String, paymentMethod: PaymentMethodParams, transaction: TransactionParams) {
        self.paymentId = paymentId
        self.paymentMethod = paymentMethod
        self.transaction = transaction
    }
}
