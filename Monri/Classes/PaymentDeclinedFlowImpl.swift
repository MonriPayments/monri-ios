//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation
import os.log

class PaymentDeclinedFlowImpl: PaymentDeclinedFlow {
    weak var vc: ConfirmPaymentControllerViewController?
    public let clientSecret: String

    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "PaymentDeclinedFlow"))
    }

    init(vc: ConfirmPaymentControllerViewController?, clientSecret: String) {
        self.vc = vc
        self.clientSecret = clientSecret
    }

    func handleResult(_ response: ConfirmPaymentResponse) {

        guard let vc = vc else {
            logger.warn("Invoked handleResult with payload [\(response.status)] without ViewController attached")
            return
        }

        vc.indicator.stopAnimating()
        vc.indicator.isHidden = true
        vc.webView.isHidden = true
        vc.webView.stopLoading()
        vc.result(.declined(ConfirmPaymentDeclined(status: response.status.rawValue, clientSecret: clientSecret)))
    }
}
