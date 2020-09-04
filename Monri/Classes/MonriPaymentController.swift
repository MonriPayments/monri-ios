//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log

class MonriPaymentController: PaymentController {

    weak var navigationController: UINavigationController?

    let options: MonriApiOptions

    let logger: MonriLogger = MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "MonriPaymentController"))

    init(navigationController: UINavigationController, options: MonriApiOptions) {
        self.navigationController = navigationController
        self.options = options
    }

    func confirmPayment(params: ConfirmPaymentParams,
                        _ callback: @escaping ConfirmPaymentResultCallback) {

        guard let nc = navigationController else {
            logger.warn("confirmPayment invoked with disposed navigation controller")
            return
        }

        let vc = ConfirmPaymentControllerViewController.create(confirmPaymentParams: params,
                monriApiOptions: options,
                callback: callback
        )
        nc.pushViewController(vc, animated: true)
    }
}
