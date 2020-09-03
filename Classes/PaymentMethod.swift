//
//  PaymentMethod.swift
//  Monri
//
//  Created by Jasmin Suljic on 13/11/2019.
//

import Foundation

public enum PaymentMethodType {
    case newCard
    case savedCard

}

public protocol PaymentMethod {
    func paymentMethodType() -> PaymentMethodType
    func data() -> [String: Any]
    func toPaymentMethodParams() -> PaymentMethodParams

}
