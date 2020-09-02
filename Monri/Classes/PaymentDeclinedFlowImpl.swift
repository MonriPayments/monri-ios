//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

class PaymentDeclinedFlowImpl: PaymentDeclinedFlow {
    weak var vc: ConfirmPaymentControllerViewController?

    init(vc: ConfirmPaymentControllerViewController?) {
        self.vc = vc
    }

    func handleResult(_ response: ConfirmPaymentResponse) {

    }
}
