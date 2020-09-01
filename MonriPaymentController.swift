//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class MonriPaymentController: PaymentController {

    func confirmPayment(navigationController: UINavigationController, params: ConfirmPaymentParams) {
        let vc = ConfirmPaymentControllerViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
