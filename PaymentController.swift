//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

protocol PaymentController {
    func confirmPayment(params: ConfirmPaymentParams, _ callback: @escaping ConfirmPaymentResultCallback)
}
