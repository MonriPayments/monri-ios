//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import PassKit

protocol PaymentController {
    func confirmPayment(params: ConfirmPaymentParams, applePayCustomisation: (PKPaymentButtonType, PKPaymentButtonStyle)?, _ callback: @escaping ConfirmPaymentResultCallback)
}
