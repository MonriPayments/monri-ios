//
//  CustomerPaymentMethodResponse.swift
//  Monri
//
//  Created by Adnan Omerovic on 29. 12. 2022..
//

import Foundation

public typealias CustomerPaymentMethodResponseCallback = (CustomerPaymentMethodResponseResult) -> Void

public enum CustomerPaymentMethodResponseResult {
    case result(CustomerPaymentMethodResponse)
    case error(CustomerApiError)
}

public class CustomerPaymentMethodResponse {
    public let status: String
    public let customerPaymentMethod: [CustomerPaymentMethod]

    public init(status: String, customerPaymentMethod: [CustomerPaymentMethod]) {
        self.status = status
        self.customerPaymentMethod = customerPaymentMethod
    }

    class func fromJson(_ jsonObject: [String: Any]?) -> CustomerPaymentMethodResponse? {
        guard let json = jsonObject else {
            return nil
        }

        var customerPaymentMethodArray: [CustomerPaymentMethod] = []

        let status = json["status"] as? String ?? ""

        (json["data"] as? Array<Any> ?? []).forEach { element in
            let jsonPaymentMethod = element as? Dictionary<String, Any>
            if let customerPaymentMethod = CustomerPaymentMethod.fromJson(jsonPaymentMethod) {
                customerPaymentMethodArray.append(customerPaymentMethod)
            }
        }

        return CustomerPaymentMethodResponse(
                status: status,
                customerPaymentMethod: customerPaymentMethodArray
        )
    }
}
