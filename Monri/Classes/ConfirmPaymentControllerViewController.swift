//
//  ConfirmPaymentControllerViewController.swift
//  Monri
//
//  Created by Jasmin Suljic on 01/09/2020.
//

import UIKit
import WebKit

class ConfirmPaymentControllerViewController: UIViewController {

    var webView: WKWebView!
    var indicator: UIActivityIndicatorView!

    private var callback: ConfirmPaymentResultCallback!
    private var navigationDelegate: PaymentAuthWebViewNavigationDelegate!

    private var confirmPaymentParams: ConfirmPaymentParams!
    private var monriApiOptions: MonriApiOptions!

    var monri: MonriApi {
        MonriApi(self.navigationController!, options: monriApiOptions)
    }

    static func create(confirmPaymentParams: ConfirmPaymentParams,
                       monriApiOptions: MonriApiOptions,
                       callback: @escaping ConfirmPaymentResultCallback) -> ConfirmPaymentControllerViewController {
        let vc = ConfirmPaymentControllerViewController()
        vc.confirmPaymentParams = confirmPaymentParams
        vc.monriApiOptions = monriApiOptions
        vc.callback = callback
        return vc;
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))

        view.backgroundColor = UIColor.white

        indicator.startAnimating()
        view.addSubview(indicator)
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        view.addSubview(webView)

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
//
        navigationDelegate = PaymentAuthWebViewNavigationDelegate()
        webView.navigationDelegate = navigationDelegate

        monri.paymentApi.confirmPayment(confirmPaymentParams) { [weak self] r in
            guard let vc = self else {
                return
            }
            let callback = ConfirmPaymentResponseCallback.create(vc: vc, navigationDelegate: vc.navigationDelegate)
            switch (r) {
            case .error(let e):
                callback.onError(error: e)
            case .result(let r):
                callback.onSuccess(result: r)
            }

        }
    }

    func resultReceived(statusResponse: PaymentStatusResponse) {

    }

    func paymentStatusRetryExceeded() {

    }

}
