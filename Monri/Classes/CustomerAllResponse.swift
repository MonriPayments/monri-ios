//
//  CustomerAllResponse.swift
//  Monri
//
//  Created by Adnan Omerovic on 30. 12. 2022..
//

import Foundation

public typealias CustomerAllResponseCallback = (CustomerAllResponseResult) -> Void

public enum CustomerAllResponseResult {
    case result(CustomerAllResponse)
    case error(CustomerError)
}

public class CustomerAllResponse {
    public let status: String
    public let customerResponseArray: [CustomerResponse]

    init(status: String, customerResponseArray: [CustomerResponse]) {
        self.status = status
        self.customerResponseArray = customerResponseArray
    }

    class func fromJson(_ jsonObject: [String: Any]?) -> CustomerAllResponse? {
        guard let json = jsonObject else {
            return nil
        }

        var tmpCustomerResponseArray: [CustomerResponse] = []
        let status = json["status"] as? String ?? ""

        (json["data"] as? Array<Any> ?? []).forEach { element in
            let jsonCustomer = element as? Dictionary<String, Any>
            if let customer = CustomerResponse.fromJson(jsonCustomer) {
                tmpCustomerResponseArray.append(customer)
            }
        }

        return CustomerAllResponse(status: status, customerResponseArray: tmpCustomerResponseArray)
    }
}
