//
//  ConfirmApplePayFlowTest.swift
//  Monri
//
//  Created by Karolina Škunca on 24.06.2025..
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import XCTest
import Monri
import Alamofire
import Nimble

class ConfirmApplePayFlowTest: XCTestCase {

    private let PAYMENT_ID = "paymentId"
    private let AUTHENTICITY_TOKEN = "authenticityToken"

    func testCreateShouldReturnInstanceWithValidInputParameters() {
        // Given
        let uiDelegate = FakeUiDelegate()
        let monriApiOptions = MonriApiOptions(authenticityToken: AUTHENTICITY_TOKEN, developmentMode: true, merchantID: "merchantID")
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        let monriApi = MonriApi(currentViewController, options: monriApiOptions)
        let confirmPaymentParams: ConfirmPaymentParams = ConfirmPaymentParams(paymentId: "", paymentMethod: PaymentMethodParams.init(type: "", data: [:]), transaction: TransactionParams.create())

        // When
        let confirmApplePayFlow = ConfirmApplePayFlowImpl(uiDelegate: uiDelegate,
                                                          monriApi: monriApi,
                                                          confirmPaymentParams: confirmPaymentParams)

        // Then
        expect(confirmApplePayFlow).toNot(beNil())
    }
    
    func testExecuteShouldRenderUi() {
        // Given
        let uiDelegate = FakeUiDelegate()
        let confirmPaymentParams = ConfirmPaymentParams(
            paymentId: PAYMENT_ID,
            paymentMethod: ApplePayPayment(paymentProvider: ApplePayPayment.Provider.APPLE_PAY).toPaymentMethodParams(),
            transaction: TransactionParams.create()
                .set("order_info", "iOS SDK payment session")
        )
        let monriApiOptions = MonriApiOptions(authenticityToken: AUTHENTICITY_TOKEN, developmentMode: true, merchantID: "merchantID")
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        let monriApi = MonriApi(currentViewController, options: monriApiOptions)
        
        let confirmApplePayPaymentFlow = ConfirmApplePayFlowImpl(uiDelegate: uiDelegate,
                                                                 monriApi: monriApi,
                                                                 confirmPaymentParams: confirmPaymentParams)
        
        // When
        confirmApplePayPaymentFlow.execute()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            expect(uiDelegate.isWebViewVisible()).to(beFalse())
            expect(uiDelegate.isLoadingVisible()).to(beFalse())
        }
        
    }

    func testExecuteShouldReturnExpectedPaymentResultAndRenderUiWhenPaymentStatusIsApproved() {
        // Given
        let expectation = expectation(description: "testExecuteShouldReturnExpectedPaymentResultAndRenderUiWhenPaymentStatusIsApproved")
        
        let expectedPaymentResult = PaymentResult(status: "approved",
                                                  currency: nil,
                                                  amount: nil,
                                                  orderNumber: nil,
                                                  panToken: nil,
                                                  createdAt: nil,
                                                  transactionType: nil,
                                                  paymentMethod: nil,
                                                  responseCode: nil,
                                                  responseMessage: nil,
                                                  errors: [])
        
        let paymentMethodRequiredResponse = PaymentStatusResponse(paymentStatus: .approved, status: PaymentStatus.approved.rawValue, paymentResult: expectedPaymentResult)
        
        let uiDelegate = FakeUiDelegate()
        let confirmPaymentParams = ConfirmPaymentParams(
            paymentId: PAYMENT_ID,
            paymentMethod: ApplePayPayment(paymentProvider: ApplePayPayment.Provider.APPLE_PAY).toPaymentMethodParams(),
            transaction: TransactionParams.create()
                .set("order_info", "iOS SDK payment session")
        )
        
        let monriApiOptions = MonriApiOptions(authenticityToken: AUTHENTICITY_TOKEN, developmentMode: true, merchantID: "merchantID")
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        let monriApi = MonriApi(currentViewController, options: monriApiOptions)
        
        monriApi.httpApi = FakeMonriHttpApi(paymentStatusHandler: .result(paymentMethodRequiredResponse), monriHttpApi: monriApi.httpApi)
        
        let confirmApplePayPaymentFlow = ConfirmApplePayFlowImpl(uiDelegate: uiDelegate,
                                                                 monriApi: monriApi,
                                                                 confirmPaymentParams: confirmPaymentParams)

        // When
        confirmApplePayPaymentFlow.execute()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 6, handler: nil)
        
        switch uiDelegate.getPaymentResultToHandle() {
        case .result(let paymentResult):
            expect(paymentResult.status).to(equal(PaymentStatus.approved.rawValue))
        default:
            break
        }
        
        expect(uiDelegate.isWebViewVisible()).to(beFalse())
        expect(uiDelegate.isLoadingVisible()).to(beFalse())
    }

    func testExecuteShouldReturnPaymentResultWhenMerchantIdIsNil() {
        //Given
        let expectation = expectation(description: "testExecuteShouldReturnPaymentResultWhenGetPaymentStatusReturnsError")
        
        let uiDelegate = FakeUiDelegate()
        let confirmPaymentParams = ConfirmPaymentParams(
            paymentId: PAYMENT_ID,
            paymentMethod: ApplePayPayment(paymentProvider: ApplePayPayment.Provider.APPLE_PAY).toPaymentMethodParams(),
            transaction: TransactionParams.create()
                .set("order_info", "iOS SDK payment session")
        )
        let monriApiOptions = MonriApiOptions(authenticityToken: AUTHENTICITY_TOKEN, developmentMode: true)
        let currentViewController = UIApplication.shared.keyWindow?.rootViewController ?? UIViewController()
        let monriApi = MonriApi(currentViewController, options: monriApiOptions)
        
        monriApi.httpApi = FakeMonriHttpApi(paymentStatusHandler: .error(.requestFailed("Missing Merchant ID")), monriHttpApi: monriApi.httpApi)
        
        let confirmApplePayPaymentFlow = ConfirmApplePayFlowImpl(uiDelegate: uiDelegate,
                                                                 monriApi: monriApi,
                                                                 confirmPaymentParams: confirmPaymentParams)

        // When
        confirmApplePayPaymentFlow.execute()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }

        let actualPaymentResult = uiDelegate.getPaymentResultToHandle()
        
        //Then
        expect(actualPaymentResult).to(beNil())
        waitForExpectations(timeout: 6, handler: nil)
    }
}

