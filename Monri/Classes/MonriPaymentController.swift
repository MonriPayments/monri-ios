//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log

class MonriPaymentController: PaymentController {

    weak var viewController: UIViewController?

    let options: MonriApiOptions

    let logger: MonriLogger = MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "MonriPaymentController"))

    init(viewController: UIViewController, options: MonriApiOptions) {
        self.viewController = viewController
        self.options = options
    }

    func confirmPayment(params: ConfirmPaymentParams,
                        _ callback: @escaping ConfirmPaymentResultCallback) {

        guard let vc = viewController else {
            logger.warn("confirmPayment invoked with disposed navigation controller")
            return
        }

        let next = ConfirmPaymentControllerViewController.create(confirmPaymentParams: params,
                monriApiOptions: options,
                callback: callback
        )
        
        if let vc = vc as? UINavigationController {
            vc.pushViewController(next, animated: true)
        } else {
            vc.present(next, animated: true)
        }
        
    }
}
