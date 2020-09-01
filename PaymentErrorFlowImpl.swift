//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class PaymentErrorFlowImpl: PaymentErrorFlow {

    weak var vc: ConfirmPaymentControllerViewController?

    init(vc: ConfirmPaymentControllerViewController?) {
        self.vc = vc
    }

    func handleResult(error: Error) {
        guard let vc = self.vc else {
            return
        }


    }
}
