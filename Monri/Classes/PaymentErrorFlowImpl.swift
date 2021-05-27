//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log

class PaymentErrorFlowImpl: PaymentErrorFlow {

    weak var vc: ConfirmPaymentControllerViewController?
    private let clientSecret: String

    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "PaymentErrorFlow"))
    }

    init(vc: ConfirmPaymentControllerViewController?, clientSecret: String) {
        self.vc = vc
        self.clientSecret = clientSecret
    }

    func handleResult(error: Error) {
        guard let vc = self.vc else {
            return
        }

        vc.result(.error(PaymentResultError.error(error)))
    }
}
