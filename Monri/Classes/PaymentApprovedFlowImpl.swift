//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation
import os.log

class PaymentApprovedFlowImpl: PaymentApprovedFlow {

    weak var vc: ConfirmPaymentControllerViewController?
    public let clientSecret: String

    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "PaymentApprovedFlow"))
    }

    init(vc: ConfirmPaymentControllerViewController?, clientSecret: String) {
        self.vc = vc
        self.clientSecret = clientSecret
    }

    func handleResult(_ response: ConfirmPaymentResponse) {

        guard let vc = self.vc else {
            // TODO: add client secret to confirm payment response
            logger.warn("Invoked handleResult for clientSecret = \(clientSecret) with payload \(response) without ViewController attached")
            return
        }

        guard let paymentResult = response.paymentResult else {
            logger.fatal("Invoked handleResult for clientSecret = \(clientSecret) without payment result, got \(response)")
            return
        }

        vc.indicator.stopAnimating()
        vc.indicator.isHidden = true
        vc.webView.isHidden = true
        vc.result(.result(paymentResult))
    }
}
