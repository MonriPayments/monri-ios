//
//  CustomerAllResponse.swift
//  Monri
//
//  Created by Adnan Omerovic on 30. 12. 2022..
//

import Foundation

public typealias MerchantCustomersCallback = (MerchantCustomersResult) -> Void

public enum MerchantCustomersResult {
    case result(MerchantCustomers)
    case error(CustomerApiError)
}

public class MerchantCustomers {
    public let status: String
    public let customerResponseArray: [Customer]

    init(status: String, customerResponseArray: [Customer]) {
        self.status = status
        self.customerResponseArray = customerResponseArray
    }

    class func fromJson(_ jsonObject: [String: Any]?) -> MerchantCustomers? {
        guard let json = jsonObject else {
            return nil
        }

        var tmpCustomerResponseArray: [Customer] = []
        let status = json["status"] as? String ?? ""

        (json["data"] as? Array<Any> ?? []).forEach { element in
            let jsonCustomer = element as? Dictionary<String, Any>
            if let customer = Customer.fromJson(jsonCustomer) {
                tmpCustomerResponseArray.append(customer)
            }
        }

        return MerchantCustomers(status: status, customerResponseArray: tmpCustomerResponseArray)
    }
}
