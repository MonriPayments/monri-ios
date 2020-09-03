//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public typealias ConfirmPaymentResultCallback = (ConfirmPaymentResult) -> Void
public typealias ConfirmPaymentCallback = (ConfirmPayment) -> Void

public enum ConfirmPaymentResult {
    case result(PaymentResult)
    case declined(ConfirmPaymentDeclined)
    case pending
    case error(PaymentResultError)
}

public struct ConfirmPaymentDeclined {
    public let status: String
    public let clientSecret: String

    public init(status: String, clientSecret: String) {
        self.status = status
        self.clientSecret = clientSecret
    }
}

public enum PaymentResultError: Error  {
    case requestFailed
    case confirmPaymentFailed
    case jsonParsingError(String)
    case error(Error)
}

public enum ConfirmPayment {
    case result(ConfirmPaymentResponse)
    case pending
    case error(ConfirmPaymentError)
    case unknownError(Error)
}
