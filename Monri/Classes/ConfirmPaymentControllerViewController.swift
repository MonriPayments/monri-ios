//
//  ConfirmPaymentControllerViewController.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import UIKit
import WebKit
import PassKit

class ConfirmPaymentControllerViewController: UIViewController {
    
    var webView: WKWebView!
    var indicator: UIActivityIndicatorView!
    
    private var callback: ConfirmPaymentResultCallback!
    internal var navigationDelegate: PaymentAuthWebViewNavigationDelegate!
    
    internal var confirmPaymentParams: ConfirmPaymentParams!
    internal var monriApiOptions: MonriApiOptions!
    internal var applePayCustomisation: (PKPaymentButtonType, PKPaymentButtonStyle)? = nil
    
    var confirmPaymentCallback: ConfirmPaymentResponseCallback {
        ConfirmPaymentResponseCallback.create(uiDelegate: self, monriHttpApi: monri.httpApi, confirmPaymentParams: confirmPaymentParams)
    }
    
    lazy var monri: MonriApi = {
        return MonriApi(self.navigationController ?? self, options: monriApiOptions)
    }()
    
    var applePayHandler: ApplePayHandler?
    
    static func create(confirmPaymentParams: ConfirmPaymentParams,
                       monriApiOptions: MonriApiOptions,
                       applePayCustomisation: (PKPaymentButtonType, PKPaymentButtonStyle)?,
                       callback: @escaping ConfirmPaymentResultCallback) -> ConfirmPaymentControllerViewController {
        let vc = ConfirmPaymentControllerViewController()
        vc.confirmPaymentParams = confirmPaymentParams
        vc.monriApiOptions = monriApiOptions
        vc.callback = callback
        vc.applePayCustomisation = applePayCustomisation
        
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        view.backgroundColor = UIColor.white
        
        indicator.startAnimating()
        view.addSubview(indicator)
        
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.addSubview(webView)
        
        if confirmPaymentParams.paymentMethod.type == PaymentMethodType.applePay.rawValue {
            
            confirmApplePayPayment(confirmPaymentParams: confirmPaymentParams, apiOptions: monriApiOptions)
            
            return
        }
        
        indicator.translatesAutoresizingMaskIntoConstraints = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            webView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        } else {
            webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }
        webView.isHidden = true
        
        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        if PaymentMethodType.directPayments.contains(where: { $0.rawValue == confirmPaymentParams.paymentMethod.type }) {
            
            confirmDirectPayment(confirmPaymentParams: confirmPaymentParams, apiOptions: monriApiOptions)
            
        } else {
            
            navigationDelegate = PaymentAuthWebViewNavigationDelegate()
            webView.navigationDelegate = navigationDelegate
            
            monri.httpApi.confirmPayment(confirmPaymentParams) { [weak self] r in
                guard let vc = self else {
                    return
                }
                
                switch (r) {
                case .error(let e):
                    vc.confirmPaymentCallback.onError(error: e)
                case .result(let r):
                    vc.confirmPaymentCallback.onSuccess(result: r)
                case .pending:
                    vc.result(ConfirmPaymentResult.pending)
                case .unknownError(let error):
                    vc.result(ConfirmPaymentResult.error(PaymentResultError.error(error)))
                }
            }
        }
    }
    
    func result(_ result: ConfirmPaymentResult) {
        
        guard let callback = self.callback else {
            return
        }
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            callback(result)
        }
        
        if let nv = navigationController  {
            nv.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
        
        
        CATransaction.commit()
    }
    
    func resultReceived(statusResponse: PaymentStatusResponse) {
        if let paymentResult = statusResponse.paymentResult {
            result(ConfirmPaymentResult.result(paymentResult))
        } else {
            result(.pending)
        }
    }
    
    func paymentStatusRetryExceeded() {
        result(ConfirmPaymentResult.pending)
    }
    
    func paymentError(error: Error) {
        result(ConfirmPaymentResult.error(PaymentResultError.error(error)))
    }
    
    func confirmDirectPayment(confirmPaymentParams: ConfirmPaymentParams, apiOptions: MonriApiOptions) {
        
        let navigationDelegate = DirectPaymentWebViewNavigationDelegate(delegate: self)
        
        webView.navigationDelegate = navigationDelegate
        
        let directPaymentFlow = ConfirmDirectPaymentFlowImpl(uiDelegate: self,
                                                             apiOptions: apiOptions,
                                                             monriApi: monri,
                                                             confirmPaymentParams: confirmPaymentParams)
        
        directPaymentFlow.execute()
    }
    
    func confirmApplePayPayment(confirmPaymentParams: ConfirmPaymentParams, apiOptions: MonriApiOptions) {
        
        guard let merchantID = apiOptions.merchantID else {
            result(ConfirmPaymentResult.error(PaymentResultError.merchantIdMissing))
            return
        }
        let applePayFlow = ConfirmApplePayFlowImpl(uiDelegate: self,
                                                   monriApi: monri,
                                                   confirmPaymentParams: confirmPaymentParams)
        
        let applePayHandler = ApplePayHandler(monriApi: monri.httpApi, applePayDelegate: applePayFlow, merchantID: merchantID)
        
        self.applePayHandler = applePayHandler
        
        if applePayHandler.applePayStatus().canMakePayments {
            
            //Get apple button
            guard let applePayButton = applePayHandler.createButton(paymentButtonType: applePayCustomisation?.0 ?? .checkout, paymentButtonStyle: applePayCustomisation?.1 ?? .black, confirmPaymentParams: confirmPaymentParams) else {
                
                //set error to return to previous page
                return
            }
            
            applePayButton.translatesAutoresizingMaskIntoConstraints = false
            
            self.view.addSubview(applePayButton)
            view.bringSubviewToFront(applePayButton)
            
            // Add constraints
            NSLayoutConstraint.activate([
                applePayButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                applePayButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                applePayButton.heightAnchor.constraint(equalToConstant: 50),
                applePayButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.8)
            ])
        }
        
        applePayFlow.execute()
    }
    
}

extension ConfirmPaymentControllerViewController: Delegate {
    func onPageLoadFinished() {
        hideLoading()
        showWebView()
    }
}

extension ConfirmPaymentControllerViewController: UiDelegate {
    
    func showLoading() {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func hideLoading() {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func showWebView() {
        webView.isHidden = false
    }
    
    func loadWebViewUrl(url: URLRequest) {
        webView.load(url)
    }
    
    func hideWebView() {
        webView.isHidden = true
    }
    
    func handlePaymentResult(paymentResult: ConfirmPaymentResult) {
        result(paymentResult)
    }
    
    func pending() {
        result(.pending)
    }
    
    func setFlowDelegate(delegate: TransactionAuthorizationFlowDelegate) {
        navigationDelegate.flowDelegate = delegate
    }
}
