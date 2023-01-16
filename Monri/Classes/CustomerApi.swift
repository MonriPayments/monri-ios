//
//  CustomerApi.swift
//  Monri
//
//  Created by Adnan Omerovic on 13. 1. 2023..
//

import Foundation

public class CustomerApi {
    public let httpApi: MonriHttpApi

    public init(_ httpApi: MonriHttpApi) {
        self.httpApi = httpApi
    }

    public func create(_ createCustomerParams: CreateCustomerParams, _ callback: @escaping CustomerCallback) {
        httpApi.createCustomer(createCustomerParams, callback)
    }

    public func update(_ updateCustomerParams: UpdateCustomerParams, _ callback: @escaping CustomerCallback) {
        httpApi.updateCustomer(updateCustomerParams, callback)
    }

    public func delete(_ deleteCustomerParams: DeleteCustomerParams, _ callback: @escaping DeleteCustomerCallback) {
        httpApi.deleteCustomer(deleteCustomerParams, callback)
    }

    public func get(_ retrieveCustomerParams: RetrieveCustomerParams, _ callback: @escaping CustomerCallback) {
        httpApi.retrieveCustomer(retrieveCustomerParams, callback)
    }

    public func getViaMerchantCustomerUuid(_ retrieveCustomerViaMerchantCustomerUuidParams: RetrieveCustomerViaMerchantCustomerUuidParams, _ callback: @escaping CustomerCallback) {
        httpApi.retrieveCustomerViaMerchantCustomerUuid(retrieveCustomerViaMerchantCustomerUuidParams, callback)
    }

    public func paymentMethods(_ customerPaymentMethodParams: CustomerPaymentMethodParams, _ callback: @escaping CustomerPaymentMethodResponseCallback) {
        httpApi.retrieveCustomerPaymentMethods(customerPaymentMethodParams, callback)
    }

    public func all(_ accessToken: String, _ callback: @escaping MerchantCustomersCallback) {
        httpApi.retrieveAllCustomers(accessToken, callback)
    }

}
