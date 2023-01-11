//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

public protocol MonriHttpApi {
    func confirmPayment(_ params: ConfirmPaymentParams, _ callback: @escaping ConfirmPaymentCallback)
    func paymentStatus(_ params: PaymentStatusParams, _ callback: @escaping PaymentStatusResponseResultCallback)
    func createToken(_ request: TokenRequest, paymentMethod: PaymentMethod, _ callback: @escaping TokenResultCallback)
    func createCustomer(_ params: CreateCustomerParams, _ callback: @escaping CustomerCallback)
    func updateCustomer(_ params: UpdateCustomerParams, _ callback: @escaping CustomerCallback)
    func deleteCustomer(_ params: DeleteCustomerParams, _ callback: @escaping DeleteCustomerCallback)
    func retrieveCustomer(_ params: RetrieveCustomerParams, _ callback: @escaping CustomerCallback)
    func retrieveCustomerViaMerchantCustomerUuid(_ params: RetrieveCustomerViaMerchantCustomerUuidParams, _ callback: @escaping CustomerCallback)
    func retrieveAllCustomers(_ accessToken: String, _ callback: @escaping MerchantCustomersCallback)
    func retrieveCustomerPaymentMethods(_ params: CustomerPaymentMethodParams, _ callback: @escaping CustomerPaymentMethodResponseCallback)
}
