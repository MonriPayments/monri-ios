//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class ConfirmPaymentResponseCallback {

    private let actionRequiredFlow: ActionRequiredFlow
    private let paymentApprovedFlow: PaymentApprovedFlow
    private let paymentDeclinedFlow: PaymentDeclinedFlow
    private let unknownFlow: UnknownFlow
    private let paymentErrorFlow: PaymentErrorFlow

    init(actionRequiredFlow: ActionRequiredFlow, paymentApprovedFlow: PaymentApprovedFlow, paymentDeclinedFlow: PaymentDeclinedFlow, unknownFlow: UnknownFlow, paymentErrorFlow: PaymentErrorFlow) {
        self.actionRequiredFlow = actionRequiredFlow
        self.paymentApprovedFlow = paymentApprovedFlow
        self.paymentDeclinedFlow = paymentDeclinedFlow
        self.unknownFlow = unknownFlow
        self.paymentErrorFlow = paymentErrorFlow
    }

    static func create(vc: ConfirmPaymentControllerViewController,
                       navigationDelegate: PaymentAuthWebViewNavigationDelegate) -> ConfirmPaymentResponseCallback {
        let clientSecret: String = vc.confirmPaymentParams.paymentId
        return ConfirmPaymentResponseCallback(
                actionRequiredFlow: ActionRequiredFlowImpl(vc: vc,
                        navigationDelegate: navigationDelegate,
                        monriApi: vc.monri.httpApi, clientSecret: clientSecret),
                paymentApprovedFlow: PaymentApprovedFlowImpl(vc: vc, clientSecret: clientSecret),
                paymentDeclinedFlow: PaymentDeclinedFlowImpl(vc: vc, clientSecret: clientSecret),
                unknownFlow: UnknownFlowImpl(vc: vc, clientSecret: clientSecret),
                paymentErrorFlow: PaymentErrorFlowImpl(vc: vc, clientSecret: clientSecret)
        )
    }

    func onError(error: Error) {
        paymentErrorFlow.handleResult(error: error)
    }

    func onSuccess(result: ConfirmPaymentResponse) {
        switch (result.status) {
        case .action_required:
            actionRequiredFlow.handleResult(result)
        case .approved:
            paymentApprovedFlow.handleResult(result)
        case .declined:
            paymentDeclinedFlow.handleResult(result)
        default:
            unknownFlow.handleResult(result)
        }
    }
}
