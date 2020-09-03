//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

public protocol MonriPaymentApi {
    func confirmPayment(_ params: ConfirmPaymentParams, _ callback: @escaping ConfirmPaymentCallback)
    func paymentStatus(_ params: PaymentStatusParams, _ callback: @escaping PaymentStatusResponseResultCallback)
}
