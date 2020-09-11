//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class PaymentStatusParams {
    let clientSecret: String

    public init(clientSecret: String) {
        self.clientSecret = clientSecret
    }
}
