//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class ConfirmPaymentResponse {
    let status: PaymentStatus
    let actionRequired: PaymentActionRequired?
    let paymentResult: PaymentResult?
    let id: String

    public init(status: PaymentStatus, actionRequired: PaymentActionRequired?, paymentResult: PaymentResult?, id: String) {
        self.status = status
        self.actionRequired = actionRequired
        self.paymentResult = paymentResult
        self.id = id
    }
}
