//
//  ApplePayDelegate.swift
//  Pods
//
//  Created by Karolina Škunca on 17.06.2025..
//

import PassKit

public protocol ApplePayDelegate: AnyObject {
    func onApplePaymentFinished(pkPaymentAuthorizationResult: PKPaymentAuthorizationResult, confirmPaymentResultResponse: ConfirmPaymentResponse?)
}
