//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class MonriPaymentController: PaymentController {

    weak var navigationController: UINavigationController?

    let options: MonriApiOptions

    init(navigationController: UINavigationController, options: MonriApiOptions) {
        self.navigationController = navigationController
        self.options = options
    }

    func confirmPayment(params: ConfirmPaymentParams,
                        _ callback: @escaping ConfirmPaymentResultCallback) {

        guard let nc = navigationController else {
            // TODO: log this case
            return
        }


        let vc = ConfirmPaymentControllerViewController.create(confirmPaymentParams: params, monriApiOptions: options, callback: callback) 

        nc.pushViewController(vc, animated: true)
    }
}
