//
//  ConfirmApplePayFlow.swift
//  Pods
//
//  Created by Karolina Škunca on 24.06.2025..
//

import Foundation

protocol ConfirmApplePayFlow {
    func handleResult(_ response: ConfirmPaymentResponse)
}
