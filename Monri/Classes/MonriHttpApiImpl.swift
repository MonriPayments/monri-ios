//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation
import os.log

class MonriHttpApiImpl: MonriHttpApi {

    let apiUrl: String
    let tokenizeUrl: String
    let authorizationHeader: String
    let options: MonriApiOptions
    private let httpClient: MonriHttpClient

    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "MonriPaymentApi"))
    }

    init(options: MonriApiOptions, httpClient: MonriHttpClient) {
        self.options = options
        self.apiUrl = options.apiUrl
        self.authorizationHeader = "WP3-v2-Client \(options.authenticityToken)"
        self.httpClient = httpClient
        self.tokenizeUrl = "\(apiUrl)/v2/temp-tokenize"
    }

    func confirmPayment(_ params: ConfirmPaymentParams, _ callback: @escaping ConfirmPaymentCallback) {
        httpClient.jsonPost(url: "\(apiUrl)/v2/payment/\(params.paymentId)/confirm",
                body: params.toJSON(),
                headers: ["Authorization": authorizationHeader]) {
            switch ($0) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("ConfirmPayment failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(ConfirmPaymentError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = ConfirmPaymentResponse.fromJson(body) else {
                    callback(.error(ConfirmPaymentError.jsonParsingError("Converting response to ConfirmPaymentResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.unknownError(error))
            }
        }
    }

    func createToken(_ request: TokenRequest, paymentMethod: PaymentMethod, _ callback: @escaping TokenResultCallback) {
        guard let createTokenRequest = CreateTokenRequest.from(token: request, paymentMethod: paymentMethod, authenticityToken: options.authenticityToken) else {
            callback(.error(TokenError.createTokenRequestError))
            return
        }

        httpClient.jsonPost(url: tokenizeUrl, body: createTokenRequest.toJson(), headers: [:]) {
            switch ($0) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("ConfirmPayment failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(TokenError.tokenizationFailed))
            case .success(let body, _, _):
                guard let response = Token.fromJson(body) else {
                    callback(.error(.jsonParsingError("Converting response to Token from \(body) failed!")))
                    return
                }
                callback(.token(response))
            case .error(let error):
                callback(.error(TokenError.error(error)))
            }
        }
    }

    func paymentStatus(_ params: PaymentStatusParams, _ callback: @escaping PaymentStatusResponseResultCallback) {
        httpClient.jsonGet(url: "\(apiUrl)/v2/payment/\(params.clientSecret)/status", headers: ["Authorization": authorizationHeader]) {
            switch ($0) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("ConfirmPayment failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(PaymentStatusError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = PaymentStatusResponse.fromJson(body) else {
                    callback(.error(PaymentStatusError.jsonParsingError("Converting response to ConfirmPaymentResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }
        }
    }
}
