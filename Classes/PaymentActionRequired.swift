//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class PaymentActionRequired {
    public let redirectTo: String
    public let acsUrl: String

    init(redirectTo: String, acsUrl: String) {
        self.redirectTo = redirectTo
        self.acsUrl = acsUrl
    }

    static func fromJson(_ json: Dictionary<String, Any>?) -> PaymentActionRequired? {

        guard let json = json else {
            return nil
        }

        guard let redirectTo = json["redirect_to"] as? String else {
            return nil
        }

        guard let acsUrl = json["acs_url"] as? String else {
            return nil
        }

        return PaymentActionRequired(redirectTo: redirectTo, acsUrl: acsUrl)
    }
}
