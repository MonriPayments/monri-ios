//
//  ConfirmApplePayFlowImpl.swift
//  Pods
//
//  Created by Karolina Škunca on 24.06.2025..
//

import UIKit
import PassKit

public final class ConfirmApplePayFlowImpl {
    
    private let monriApi: MonriApi
    private let confirmPaymentParams: ConfirmPaymentParams?
    
    private var uiDelegate: UiDelegate
    
    private let clientSecret: String
    
    private let paymentErrorFlow: PaymentErrorFlow
    
    public init(uiDelegate: UiDelegate,
         monriApi: MonriApi,
         confirmPaymentParams: ConfirmPaymentParams) {
        self.uiDelegate = uiDelegate
        self.monriApi = monriApi
        self.confirmPaymentParams = confirmPaymentParams
        
        self.clientSecret = confirmPaymentParams.paymentId
        
        paymentErrorFlow = PaymentErrorFlowImpl(uiDelegate: uiDelegate, clientSecret: clientSecret)
        
    }
    
    func checkPaymentStatus(clientSecret: String) {
        monriApi.httpApi.paymentStatus(PaymentStatusParams(clientSecret: clientSecret)) {
            result in
            switch (result) {
            case .error(let e):
                
                switch e {
                case .requestFailed(let string):
                    self.paymentErrorFlow.handleResult(error: NSError(domain: string, code: 0))
                case .confirmPaymentFailed:
                    self.paymentErrorFlow.handleResult(error: NSError(domain: "confirmApplePayFailed", code: 0))
                case .jsonParsingError(let string):
                    self.paymentErrorFlow.handleResult(error: NSError(domain: string, code: 0))
                case .unknownError(let error):
                    self.paymentErrorFlow.handleResult(error: error)
                }
            case .result(let r):
                
                switch r.paymentStatus {
                    
                case .approved, .declined, .executed:
                    DispatchQueue.main.async {
                        self.handleResult(ConfirmPaymentResponse(status: r.paymentStatus, actionRequired: nil, paymentResult: r.paymentResult))
                    }
                case .action_required:
                    break
                case .payment_method_required:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.checkPaymentStatus(clientSecret: clientSecret)
                    }
                }
            }
        }
    }
    
    public func execute() {
        uiDelegate.hideWebView()
        uiDelegate.hideLoading()
    }
    
}

extension ConfirmApplePayFlowImpl: ConfirmApplePayFlow {
    
    func handleResult(_ response: ConfirmPaymentResponse) {
        
        uiDelegate.hideLoading()
        uiDelegate.hideWebView()
        
        if let paymentResult = response.paymentResult {
            
            uiDelegate.handlePaymentResult(paymentResult: .result(paymentResult))
        } else {
            
            uiDelegate.pending()
        }
        
    }
}

extension ConfirmApplePayFlowImpl: ApplePayDelegate {
    public func onApplePaymentFinished(pkPaymentAuthorizationResult: PKPaymentAuthorizationResult, confirmPaymentResultResponse: ConfirmPaymentResponse?) {
        
        switch pkPaymentAuthorizationResult.status {
        case .failure:
            
            let error = pkPaymentAuthorizationResult.errors.first ?? NSError(domain: "", code: 0, userInfo: nil)
            
            uiDelegate.handlePaymentResult(paymentResult: .error(.error(error)))
        case .success:
            checkPaymentStatus(clientSecret: clientSecret)
        default:
            uiDelegate.handlePaymentResult(paymentResult: .error(.error(NSError(domain: "", code: 0, userInfo: nil))))
        }
    }
}


