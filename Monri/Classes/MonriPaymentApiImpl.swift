//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation
import Alamofire

class MonriPaymentApiImpl: MonriPaymentApi {

    let apiUrl: String
    let authorizationHeader: String

    init(apiUrl: String, options: MonriApiOptions) {
        self.apiUrl = apiUrl
        self.authorizationHeader = "WP3-v2-Client \(options.authenticityToken)"
    }

    func confirmPayment(_ params: ConfirmPaymentParams, _ callback: @escaping ConfirmPaymentCallback) {
        Alamofire.request("\(apiUrl)/v2/payment/\(params.paymentId)/confirm",
                        method: .post,
                        parameters: params.toJSON(),
                        encoding: JSONEncoding.default,
                        headers: ["Authorization": authorizationHeader]
                        )
                .responseJSON { dataResponse in
                    guard let data = dataResponse.data else {
                        callback(.error(ConfirmPaymentError.confirmPaymentFailed))
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            callback(.error(ConfirmPaymentError.jsonParsingError("Converting response = \(data) to JSON failed!")))
                            return
                        }
                        guard let result = ConfirmPaymentResponse.fromJson(json) else {
                            callback(.error(ConfirmPaymentError.jsonParsingError("Converting response to ConfirmPaymentResponse from \(json) failed!")))
                            return
                        }

                        callback(.result(result))
                    } catch {
                        callback(.error(ConfirmPaymentError.jsonParsingError("\(error)")))
                    }
                }
    }

    func paymentStatus(_ params: PaymentStatusParams, _ callback: @escaping PaymentStatusResponseResultCallback) {
        Alamofire.request("\(apiUrl)/v2/payment/\(params.clientSecret)/status",
                        method: .get,
                        encoding: JSONEncoding.default,
                        headers: ["Authorization": authorizationHeader])
                .responseJSON { dataResponse in
                    guard let data = dataResponse.data else {
                        callback(.error(PaymentStatusError.confirmPaymentFailed))
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            callback(.error(PaymentStatusError.jsonParsingError("Converting response = \(data) to JSON failed!")))
                            return
                        }
                        guard let response = PaymentStatusResponse.fromJson(json) else {
                            callback(.error(PaymentStatusError.jsonParsingError("Converting response to PaymentResult from \(json) failed!")))
                            return
                        }

                        callback(.result(response))
                    } catch {
                        callback(.error(PaymentStatusError.jsonParsingError("\(error)")))
                    }
                }
    }
}
