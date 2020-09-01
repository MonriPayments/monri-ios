//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public typealias ConfirmPaymentResultCallback = (ConfirmPaymentResult) -> Void

public enum ConfirmPaymentResult {
    case result(PaymentResult)
    case error(ConfirmPaymentError)
}
