//
//  ApplePayPayment.swift
//  Pods
//
//  Created by Karolina Škunca on 03.06.2025..
//

import Foundation

public class ApplePayPayment {
    
    private let paymentProvider: Provider
    
    public init(paymentProvider: Provider) {
        self.paymentProvider = paymentProvider
    }
}

extension ApplePayPayment: PaymentMethod {
    public func paymentMethodType() -> PaymentMethodType {
        return PaymentMethodType.applePay
    }
    
    public func data() -> [String : Any] {
        return [:]
    }
    
    public func toPaymentMethodParams() -> PaymentMethodParams {
        return PaymentMethodParams(type: paymentProvider.paymentMethod, data: data())
    }
    
    public enum Provider {
    
        case APPLE_PAY
        
        public var paymentMethod: String {
            switch self {
            case .APPLE_PAY:
                return PaymentMethodType.applePay.rawValue
            }
        }
    }
}



