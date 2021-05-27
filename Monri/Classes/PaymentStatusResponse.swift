//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log

public class PaymentStatusResponse {
    public let paymentStatus: PaymentStatus
    public let status: String
    public let paymentResult: PaymentResult?

    static let logger: MonriLogger = MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "PaymentStatusResponse"))

    public init(paymentStatus: PaymentStatus, status: String, paymentResult: PaymentResult?) {
        self.paymentStatus = paymentStatus
        self.status = status
        self.paymentResult = paymentResult
    }

    public static func fromJson(_ json: Dictionary<String, Any>) -> PaymentStatusResponse? {

        logger.trace("Creating PaymentStatusResponse from [\(json)]")

        guard let paymentStatus = json["payment_status"] as? String else {
            return nil;
        }

        guard let status = json["status"] as? String else {
            return nil;
        }

        let paymentResult: PaymentResult? = PaymentResult.fromJson(json["payment_result"] as? [String: Any])

        return PaymentStatusResponse(paymentStatus: PaymentStatus.init(rawValue: paymentStatus)!, status: status, paymentResult: paymentResult)
    }
}
