//
//  ApplePayHandler.swift
//  Pods
//
//  Created by Karolina Škunca on 03.06.2025..
//

import Foundation
import PassKit
import os.log

public class ApplePayHandler: NSObject {
    
    private let monriApi: MonriHttpApi
    private var confirmPaymentParams: ConfirmPaymentParams?
    
    var applePaymentInfo: ApplePaymentInfo?
    var applePayDelegate: ApplePayDelegate?
    var supportedNetworks: [PKPaymentNetwork] = [PKPaymentNetwork]()
    var merchantID: String
    
    var paymentController: PKPaymentAuthorizationController?
    public var paymentSummaryItems = [PKPaymentSummaryItem]()
    var pkPaymentAuthorizationResult: PKPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: .failure, errors: nil)
    var confirmPaymentResponse: ConfirmPaymentResponse? = nil
    
    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ApplePayHandler"))
    }
    
    public init(monriApi: MonriHttpApi,
                applePayDelegate: ApplePayDelegate?,
                merchantID: String) {
        
        self.monriApi = monriApi
        
        self.applePayDelegate = applePayDelegate
        self.merchantID = merchantID
        
    }
    
    public func createButton(paymentButtonType: PKPaymentButtonType, paymentButtonStyle: PKPaymentButtonStyle, confirmPaymentParams: ConfirmPaymentParams) -> UIButton? {
        
        self.confirmPaymentParams = confirmPaymentParams
        
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
            logger.warn("ApplePay: clientSecret is nil")
            self.applePayDelegate?.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult, confirmPaymentResultResponse: self.confirmPaymentResponse)
            return
        }
        
        monriApi.startApplePay(ApplePayParams(clientSecret: clientSecret)) { result in
            
            guard let result = result else {
                self.logger.warn("ApplePay: Unable to start ApplePay")
                self.applePayDelegate?.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult, confirmPaymentResultResponse: self.confirmPaymentResponse)
                return
            }
            
            switch result {
            case .result(let applePaymentInfo):
                self.applePaymentInfo = applePaymentInfo
                
                let pkPaymentSummaryItem = PKPaymentSummaryItem(label: applePaymentInfo.total.label, amount: NSDecimalNumber(string: String(applePaymentInfo.total.amount)), type: .final)
                
                self.paymentSummaryItems.append(pkPaymentSummaryItem)
                
                for networkName in applePaymentInfo.supportedNetworks {
                    if let network = self.paymentNetwork(from: networkName) {
                        self.supportedNetworks.append(network)
                    } else {
                        self.logger.warn("ApplePay: Unsupported or unknown network: \(networkName)")
                    }
                }
                
                let paymentRequest = PKPaymentRequest()
                paymentRequest.paymentSummaryItems = self.paymentSummaryItems
                paymentRequest.merchantIdentifier = self.merchantID
                paymentRequest.merchantCapabilities = .threeDSecure
                paymentRequest.countryCode = applePaymentInfo.countryCode
                paymentRequest.currencyCode = applePaymentInfo.currencyCode
                paymentRequest.supportedNetworks = self.supportedNetworks
                paymentRequest.shippingType = .delivery
                
                self.paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
                self.paymentController!.delegate = self
                self.paymentController!.present(completion: { (presented: Bool) in
                    if presented {
                        self.logger.info("ApplePay: Payment controller presented")
                    } else {
                        self.logger.info("ApplePay: Failed to present payment controller")
                        self.applePayDelegate?.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult, confirmPaymentResultResponse: self.confirmPaymentResponse)
                    }
                })
                
            case .error(let applePaymentApiError):
                self.logger.warn("ApplePay: Unable to start payment: \(applePaymentApiError)")
                self.applePayDelegate?.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult, confirmPaymentResultResponse: self.confirmPaymentResponse)
                return
            }
            
        }
        
    }
    
}

extension ApplePayHandler: PKPaymentAuthorizationControllerDelegate {
    
    public func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        let status = PKPaymentAuthorizationStatus.success
        
        guard let params = prepareDataForConfirmPayment(paymentToken: payment.token) else {
            self.pkPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: status, errors: nil)
            return
        }
        
        monriApi.confirmPayment(params) { [weak self] r in
            
            guard let `self` = self else { return }
            
            switch (r) {
            case .error(let error):
                self.logger.warn("ApplePay: Unknown error occurred with confirm payment: \(error)")
                self.pkPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: .failure, errors: [error])
                self.applePayDelegate?.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult, confirmPaymentResultResponse: self.confirmPaymentResponse)
                completion(self.pkPaymentAuthorizationResult)
            case .result(let r):
                
                self.confirmPaymentResponse = r
                self.pkPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: status, errors: nil)
                completion((self.pkPaymentAuthorizationResult))
                
            case .pending:
                self.logger.info("ApplePay: Pending transaction")
                completion(self.pkPaymentAuthorizationResult)
                return
            case .unknownError(let error):
                self.logger.warn("ApplePay: Unknown error occurred with confirm payment: \(error)")
                self.pkPaymentAuthorizationResult = PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.failure, errors: [error])
                completion(self.pkPaymentAuthorizationResult)
            }
        }
        
        
    }
    
    public func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss {
            DispatchQueue.main.async {
                self.applePayDelegate?.onApplePaymentFinished(pkPaymentAuthorizationResult: self.pkPaymentAuthorizationResult, confirmPaymentResultResponse: self.confirmPaymentResponse)
            }
        }
    }
    
    private func prepareDataForConfirmPayment(paymentToken: PKPaymentToken) -> ConfirmPaymentParams? {
        guard let params = confirmPaymentParams, let paymentTokenToJson = try? buildApplePayTokenJSON(from: paymentToken) else { return nil }
        
        let paymentMethod: PaymentMethodParams = PaymentMethodParams(type: PaymentMethodType.applePay.rawValue, data: paymentTokenToJson)
        
        let version: String = Bundle(identifier: "org.cocoapods.Monri")?.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        
        let transaction = params.transaction
            .set("meta.\(MetaUtility.INTEGRATION_TYPE_KEY)", "ios-sdk")
            .set("meta.\(MetaUtility.LIBRARY_KEY)", MonriUtil.library())
            .set("meta.\(MetaUtility.LIBRARY_VERSION_KEY)", version)
        
        return ConfirmPaymentParams(paymentId: params.paymentId, paymentMethod: paymentMethod, transaction: transaction)
        
    }
    
    private func buildApplePayTokenJSON(from payment: PKPaymentToken) throws -> [String: Any] {
        
        // 1. Decode paymentData JSON from PKPaymentToken
        let paymentDataObject = try JSONSerialization.jsonObject(with: payment.paymentData, options: []) as? [String: Any]
        
        // 2. Assemble the final JSON dictionary
        let result: [String: Any] = [
            "transactionIdentifier": payment.transactionIdentifier,
            "paymentData": paymentDataObject ?? [:],
            "paymentMethod": [
                "type": payment.paymentMethod.type.stringValue,
                "displayName": payment.paymentMethod.displayName,
                "network": payment.paymentMethod.network?.rawValue
            ]
        ]
        
        return result
    }
    
}

extension ApplePayHandler {
    func paymentNetwork(from string: String) -> PKPaymentNetwork? {
        
        switch string.lowercased() {
        case "amex": return .amex
        case "visa": return .visa
        case "mastercard": return .masterCard
        case "discover": return .discover
        case "interac": return .interac
        case "private label", "privatelabel": return .privateLabel
        case "chinaunionpay", "unionpay": return .chinaUnionPay
        case "jcb": return .JCB
        case "suica": return .suica
        case "quicpay": return .quicPay
        case "id": return .idCredit
        case "eftpos": return .eftpos
        case "electron": return .electron
        case "maestro": return .maestro
        case "vpay": return .vPay
        case "mada":
            if #available(iOS 12.1.1, *) {
                return .mada
            }
        case "cartesbancaires", "cartebancaire":
            if #available(iOS 12.0, *) {
                return .cartesBancaires
            }
        case "girocard":
            if #available(iOS 14.0, *) {
                return .girocard
            }
        case "mir":
            if #available(iOS 15.5, *) {
                return .mir
            }
        case "elo":
            if #available(iOS 16.0, *) {
                return .elo
            }
        case "barcode":
            if #available(iOS 16.4, *) {
                return .barcode
            }
        default:
            return nil
        }
        
        return nil
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
        case .eMoney: return "eMoney"
        @unknown default: return "unknown"
        }
    }
}

