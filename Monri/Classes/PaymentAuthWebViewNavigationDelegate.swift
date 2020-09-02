//
// Created by Jasmin Suljic on 02/09/2020.
//

import Foundation
import WebKit
import os.log

class PaymentAuthWebViewNavigationDelegate: NSObject, WKNavigationDelegate {

    var acsUrl: String? = nil

    var flowDelegate: TransactionAuthorizationFlowDelegate? = nil

    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "PaymentAuthWebViewClient"))
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        logger.info(message: "didCommit %@", webView.url)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!) {
        logger.info(message: "didFail %@", webView.url)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        logger.info(message: "didFinish %@", webView.url)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        logger.info(message: "didFail %@ with error", webView.url, error)
    }
}

protocol TransactionAuthorizationFlowDelegate {
    func threeDs1Result(status: String, clientSecret: String)
    func redirectingToAcs()
    func acsLoadFinished()
    func acsAuthenticationFinished()
}
