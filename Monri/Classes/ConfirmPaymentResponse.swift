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

    static func fromJson(_ json: Dictionary<String, Any>?) -> ConfirmPaymentResponse? {

        guard let json = json else {
            return nil
        }

        guard let status = json["status"] as? String else {
            return nil
        }

        guard let parsedStatus = PaymentStatus.init(rawValue: status) else {
            return nil
        }

        guard let id = json["id"] as? String else {
            return nil
        }

        let actionRequired = PaymentActionRequired.fromJson(json["action_required"] as? Dictionary<String, Any>)
        let paymentResult = PaymentResult.fromJson(json["payment_result"] as? Dictionary<String, Any>)

        return ConfirmPaymentResponse(status: parsedStatus, actionRequired: actionRequired, paymentResult: paymentResult, id: id)
    }
}
