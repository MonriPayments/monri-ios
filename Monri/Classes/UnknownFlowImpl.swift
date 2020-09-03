//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

class UnknownFlowImpl: UnknownFlow {
    weak var vc: ConfirmPaymentControllerViewController?

    private let clientSecret: String

    init(vc: ConfirmPaymentControllerViewController?, clientSecret: String) {
        self.vc = vc
        self.clientSecret = clientSecret
    }

    func handleResult(_ response: ConfirmPaymentResponse) {

    }
}
