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

    func createCustomer(_ params: CreateCustomerParams, _ callback: @escaping CustomerCallback) {
        httpClient.jsonPost(
                url: "\(apiUrl)/v2/customers",
                body: params.customerData.toJSON(),
                headers: ["Authorization": params.accessToken]
        ) {

            switch ($0) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("createCustomer failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = Customer.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to CustomerResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }
        }

    }

    func updateCustomer(_ params: UpdateCustomerParams, _ callback: @escaping CustomerCallback) {
        httpClient.jsonPost(
                url: "\(apiUrl)/v2/customers/\(params.customerUuid)",
                body: params.customerData.toJSON(),
                headers: ["Authorization": params.accessToken]
        ) {

            switch ($0) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("createCustomer failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = Customer.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to CustomerResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }
        }
    }

    func deleteCustomer(_ params: DeleteCustomerParams, _ callback: @escaping DeleteCustomerCallback) {
        httpClient.jsonDelete(
                url: "\(apiUrl)/v2/customers/\(params.customerUuid)",
                headers: ["Authorization": params.accessToken]
        ) { response in

            switch (response) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("createCustomer failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.jsonParsingError("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = DeleteCustomerResponse.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to CustomerDeleteResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }
        }
    }

    func retrieveCustomer(_ params: RetrieveCustomerParams, _ callback: @escaping CustomerCallback) {
        httpClient.jsonGet(
                url: "\(apiUrl)/v2/customers/\(params.customerUuid)",
                headers: ["Authorization": params.accessToken]
        ) { response in

            switch (response) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("createCustomer failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = Customer.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to CustomerResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }

        }
    }

    func retrieveCustomerViaMerchantCustomerUuid(_ params: RetrieveCustomerViaMerchantCustomerUuidParams, _ callback: @escaping CustomerCallback) {
        httpClient.jsonGet(
                url: "\(apiUrl)/v2/merchants/customers/\(params.merchantCustomerUuid)",
                headers: ["Authorization": params.accessToken]
        ) { response in

            switch (response) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("createCustomer failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = Customer.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to CustomerResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }

        }
    }

    func retrieveAllCustomers(_ accessToken: String, _ callback: @escaping MerchantCustomersCallback) {
        httpClient.jsonGet(
                url: "\(apiUrl)/v2/customers",
                headers: ["Authorization": accessToken]
        ) { response in
            switch (response) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("retrieveAllCustomers failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = MerchantCustomers.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to retrieveAllCustomers from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }
        }
    }

    func retrieveCustomerPaymentMethods(_ params: CustomerPaymentMethodParams, _ callback: @escaping CustomerPaymentMethodResponseCallback) {
        httpClient.jsonGet(
                url: "\(apiUrl)/v2/customers/\(params.customerUuid)/payment-methods?limit=\(params.limit)&offset=\(params.offset)",
                headers: ["Authorization": params.accessToken]
        ) { response in

            switch (response) {
            case .failure(let body, let statusCode, _):
                self.logger.warn("getPaymentMethodsForCustomer failed with body [\(body)] and status code [\(statusCode)]")
                callback(.error(CustomerApiError.requestFailed("Got status code \(statusCode)")))
            case .success(let body, _, _):
                guard let response = CustomerPaymentMethodResponse.fromJson(body) else {
                    callback(.error(CustomerApiError.jsonParsingError("Converting response to CustomerPaymentMethodResponse from \(body) failed!")))
                    return
                }
                callback(.result(response))
            case .error(let error):
                callback(.error(.unknownError(error)))
            }
        }
    }
}
