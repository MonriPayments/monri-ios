//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public enum ConfirmPaymentError: Error  {
    case requestFailed(String)
    case confirmPaymentFailed
    case jsonParsingError(String)
}
