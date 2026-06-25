//
//  ConfirmPaymentParams.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public class ConfirmPaymentParams {
    public let paymentId: String
    public let paymentMethod: PaymentMethodParams
    public let transaction: TransactionParams
    public let browserInfo: BrowserInfo

    public init(paymentId: String,
                paymentMethod: PaymentMethodParams,
                transaction: TransactionParams,
                browserInfo: BrowserInfo = BrowserInfo.create()) {
        self.paymentId = paymentId
        self.paymentMethod = paymentMethod
        self.transaction = transaction
        self.browserInfo = browserInfo
    }

    func toJSON() -> Dictionary<String, Any> {
        var transactionJson = transaction.toJSON()
        transactionJson["browser_info"] = browserInfo.toJSON()
        
        return [
            "payment_method": paymentMethod.toJSON(),
            "transaction": transactionJson
        ]
    }

}
 
