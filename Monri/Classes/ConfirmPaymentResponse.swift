//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log
public class ConfirmPaymentResponse {
    public let status: PaymentStatus
    public let actionRequired: PaymentActionRequired?
    public let paymentResult: PaymentResult?

    static let logger: MonriLogger = MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ConfirmPaymentResponse"))

    public init(status: PaymentStatus, actionRequired: PaymentActionRequired?, paymentResult: PaymentResult?) {
        self.status = status
        self.actionRequired = actionRequired
        self.paymentResult = paymentResult
    }

    static func fromJson(_ json: Dictionary<String, Any>?) -> ConfirmPaymentResponse? {

        guard let json = json else {
            logger.warn("Attempted creating ConfirmPaymentResponse from nil json")
            return nil
        }

        guard let status = json["status"] as? String else {
            logger.warn("Attempted creating ConfirmPaymentResponse, status is not a String, got = [\(json)]")
            return nil
        }

        guard let parsedStatus = PaymentStatus.init(rawValue: status) else {
            logger.warn("Attempted creating ConfirmPaymentResponse, status parsing failed, got [\(status)], json [\(json)]")
            return nil
        }

        let actionRequired = PaymentActionRequired.fromJson(json["action_required"] as? Dictionary<String, Any>)
        let paymentResult = PaymentResult.fromJson(json["payment_result"] as? Dictionary<String, Any>)

        return ConfirmPaymentResponse(status: parsedStatus, actionRequired: actionRequired, paymentResult: paymentResult)
    }
}
