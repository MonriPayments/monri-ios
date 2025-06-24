//
//  ApplePayHandler.swift
//  Pods
//
//  Created by Karolina Škunca on 03.06.2025..
//


import Foundation
import PassKit

public class ApplePayHandler: NSObject {
    
    private let monriApi: MonriApi
    private let apiOptions: MonriApiOptions?
    private let confirmPaymentParams: ConfirmPaymentParams?
    
    var applePaymentInfo: ApplePaymentInfo?
    var applePayDelegate: ApplePayDelegate
    var supportedNetworks: [PKPaymentNetwork] = [PKPaymentNetwork]()
    var merchantID: String
    
    var paymentController: PKPaymentAuthorizationController?
    public var paymentSummaryItems = [PKPaymentSummaryItem]()
    var pkPaymentAuthorizationResult: PKPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: .failure, errors: nil)
    
    public init(apiOptions: MonriApiOptions,
                monriApi: MonriApi,
                confirmPaymentParams: ConfirmPaymentParams,
                applePayDelegate: ApplePayDelegate,
                merchantID: String) {
        
        self.monriApi = monriApi
        self.apiOptions = apiOptions
        self.confirmPaymentParams = confirmPaymentParams
        
        self.applePayDelegate = applePayDelegate
        self.merchantID = merchantID

    }
    
    public func createButton(paymentButtonType: PKPaymentButtonType, paymentButtonStyle: PKPaymentButtonStyle) -> UIButton? {
        let result = applePayStatus()
        
        var button: UIButton?

        if result.canMakePayments {
            button = PKPaymentButton(paymentButtonType: paymentButtonType, paymentButtonStyle: paymentButtonStyle)
            button?.addTarget(self, action: #selector(startPayment), for: .touchUpInside)
            return button
        }
        
        return nil
    }
    
    public func applePayStatus() -> (canMakePayments: Bool, canSetupCards: Bool) {
        return (PKPaymentAuthorizationController.canMakePayments(),
                PKPaymentAuthorizationController.canMakePayments(usingNetworks: supportedNetworks))
    }
    
    @objc public func startPayment() {
        
        guard let clientSecret = confirmPaymentParams?.paymentId else {
            //delegate error
            self.applePayDelegate.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult)
            return
        }
        
        monriApi.httpApi.startApplePay(ApplePayParams(clientSecret: clientSecret)) { result in
            
            guard let result = result else {
                //delegate error
                self.applePayDelegate.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult)
                return
            }
            
            switch result {
            case .result(let applePaymentInfo):
                self.applePaymentInfo = applePaymentInfo
                
                let pkPaymentSummaryItem = PKPaymentSummaryItem(label: applePaymentInfo.total.label, amount: NSDecimalNumber(string: String(applePaymentInfo.total.amount)), type: .final)
                self.paymentSummaryItems.append(pkPaymentSummaryItem)
                
                
                for network in applePaymentInfo.supportedNetworks {
                    self.supportedNetworks.append(PKPaymentNetwork(network))
                }
                
                let paymentRequest = PKPaymentRequest()
                paymentRequest.paymentSummaryItems = self.paymentSummaryItems
                paymentRequest.merchantIdentifier = self.merchantID
                paymentRequest.merchantCapabilities = .threeDSecure
                paymentRequest.countryCode = applePaymentInfo.countryCode
                paymentRequest.currencyCode = applePaymentInfo.currencyCode
                paymentRequest.supportedNetworks = [.amex, .visa, .masterCard] //TODO:  Why not network working
                paymentRequest.shippingType = .delivery
                //paymentRequest.requiredShippingContactFields = [.name, .postalAddress]
                
                // Display the payment request.
                self.paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
                self.paymentController!.delegate = self
                self.paymentController!.present(completion: { (presented: Bool) in
                    if presented {
                        debugPrint("Presented payment controller")
                        
                    } else {
                        debugPrint("Failed to present payment controller")
                        self.applePayDelegate.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult)
                    }
                })
                
            case .error(let applePaymentApiError):
                //delegate error
                debugPrint(applePaymentApiError)
                self.applePayDelegate.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult)
                return
            }
            
        }
        
    }
}

extension ApplePayHandler: PKPaymentAuthorizationControllerDelegate {
    
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        // Perform basic validation on the provided contact information.
        let errors = [Error]()
        let status = PKPaymentAuthorizationStatus.success

        
        //token poslati u confirm payment params
        let params = prepareDataForConfirmPayment(paymentToken: payment.token)
        
        monriApi.httpApi.confirmPayment(params!) { [weak self] r in
            switch (r) {
            case .error(let e):
                debugPrint(e)
                self?.pkPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: .failure, errors: errors)
                self?.applePayDelegate.onApplePaymentFinished(pkPaymentAuthorizationResult: self!.pkPaymentAuthorizationResult)
                completion(self!.pkPaymentAuthorizationResult)
            case .result(let r):
                
                self?.pkPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: status, errors: nil)
                completion((self?.pkPaymentAuthorizationResult)!)
                
            case .pending:
                completion(self!.pkPaymentAuthorizationResult)
                return
            case .unknownError(let error):
                completion(self!.pkPaymentAuthorizationResult)
                debugPrint(error)
            }
        }
        
        
    }
    
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            // The payment sheet doesn't automatically dismiss once it has finished. Dismiss the payment sheet.
            DispatchQueue.main.async {
                self.applePayDelegate.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult)
            }
        }
    }
    
    private func prepareDataForConfirmPayment(paymentToken: PKPaymentToken) -> ConfirmPaymentParams? {
        guard let params = confirmPaymentParams, let paymentTokenToJson = try? buildApplePayTokenJSON(from: paymentToken) else { return nil }
        
        let paymentMethod: PaymentMethodParams = PaymentMethodParams(type: PaymentMethodType.applePay.rawValue, data: ["payment-method-data" : paymentTokenToJson])
        
        return ConfirmPaymentParams(paymentId: params.paymentId,
                                    paymentMethod: paymentMethod,
                                    transaction: params.transaction)
            
    }
    
    func buildApplePayTokenJSON(from payment: PKPaymentToken) throws -> [String: Any] {
        
        // 1. Decode paymentData JSON from PKPaymentToken
        let paymentDataObject = try JSONSerialization.jsonObject(with: payment.paymentData, options: []) as? [String: Any]
        
        // 2. Assemble the final JSON dictionary
        let result: [String: Any] = [
            "token": [
                "transactionIdentifier": payment.transactionIdentifier,
                "paymentData": paymentDataObject ?? [:],
                "paymentMethod": [
                    "type": payment.paymentMethod.type.stringValue,
                    "displayName": payment.paymentMethod.displayName,
                    "network": payment.paymentMethod.network?.rawValue
                ]
            ]
        ]
        
        return result
    }
    
}

extension PKPaymentMethodType {
    var stringValue: String {
        switch self {
        case .unknown: return "unknown"
        case .debit: return "debit"
        case .credit: return "credit"
        case .prepaid: return "prepaid"
        case .store: return "store"
        @unknown default: return "unknown"
        }
    }
}

