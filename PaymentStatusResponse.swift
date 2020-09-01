//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class PaymentStatusResponse {
    let paymentStatus: PaymentStatus
    let status: String
    let paymentResult: PaymentResult?

    public init(paymentStatus: PaymentStatus, status: String, paymentResult: PaymentResult?) {
        self.paymentStatus = paymentStatus
        self.status = status
        self.paymentResult = paymentResult
    }

    static func fromJson(_ json: Dictionary<String, Any>) -> PaymentStatusResponse? {

        guard let paymentStatus = json["payment_status"] as? String else {
            return nil;
        }

        guard let status = json["status"] as? String else {
            return nil;
        }

        let paymentResult: PaymentResult? = PaymentResult.fromJson(json["payment_result"] as? Dictionary<String, Any>)

        return PaymentStatusResponse(paymentStatus: PaymentStatus.init(rawValue: paymentStatus)!, status: status, paymentResult: paymentResult)
    }
}
