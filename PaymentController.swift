//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

protocol PaymentController {
    func confirmPayment(navigationController: UINavigationController, params: ConfirmPaymentParams)
}
