//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class MonriPaymentController: PaymentController {

    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func confirmPayment(params: ConfirmPaymentParams,
                        _ callback: @escaping ConfirmPaymentResultCallback) {

        guard let nc = navigationController else {
            // TODO: log this case
            return
        }

        let vc = ConfirmPaymentControllerViewController()
        vc.callback = callback
        nc.pushViewController(vc, animated: true)
    }
}
