//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation

public protocol MonriHttpApi {
    func confirmPayment(_ params: ConfirmPaymentParams, _ callback: @escaping ConfirmPaymentCallback)
    func paymentStatus(_ params: PaymentStatusParams, _ callback: @escaping PaymentStatusResponseResultCallback)
    func createToken(_ request: TokenRequest, paymentMethod: PaymentMethod, _ callback: @escaping TokenResultCallback)
    func createCustomer(_ request: CustomerCreateRequest, _ callback: @escaping CustomerResponseCallback)
    func updateCustomer(_ request: CustomerUpdateRequest, _ callback: @escaping CustomerResponseCallback)
    func deleteCustomer(_ request: CustomerDeleteRequest, _ callback: @escaping CustomerDeleteCallback)
    func retrieveCustomer(_ request: CustomerRetrieveRequest, _ callback: @escaping CustomerResponseCallback)
    func retrieveAllCustomers(_ accessToken: String, _ callback: @escaping CustomerAllResponseCallback)
    func retrieveCustomerViaMerchantId(_ request: CustomerRetrieveMerchantIdRequest, _ callback: @escaping CustomerResponseCallback)
    func getPaymentMethodsForCustomer(_ request: CustomerPaymentMethodRequest, _ callback: @escaping CustomerPaymentMethodResponseCallback)
}
