//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

public enum PaymentStatusError {
    case requestFailed
    case confirmPaymentFailed
    case jsonParsingError(String)
}
