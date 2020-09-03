//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

public typealias PaymentStatusResponseResultCallback = (PaymentStatusResponseResult) -> Void

public enum PaymentStatusResponseResult {
    case result(PaymentStatusResponse)
    case error(PaymentStatusError)
}
