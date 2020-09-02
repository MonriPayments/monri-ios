//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation
import os.log

class ActionRequiredFlowImpl: ActionRequiredFlow {

//    private final PaymentAuthWebView webView;
//    private final ProgressBar progressBar;
//    private final MonriApi monriApi;

    weak var vc: ConfirmPaymentControllerViewController?

    let atomicInteger = AtomicInteger()
    let monriApi: MonriPaymentApi

    var logger: MonriLogger {
        MonriLoggerImpl(log: OSLog(subsystem: "Monri", category: "ActionRequiredFlow"))
    }

    var invocationState: InvocationState = InvocationState.CALLBACK_NOT_INVOKED
    let navigationDelegate: PaymentAuthWebViewNavigationDelegate

    init(vc: ConfirmPaymentControllerViewController,
         navigationDelegate: PaymentAuthWebViewNavigationDelegate,
         monriApi: MonriPaymentApi) {
        self.vc = vc
        self.navigationDelegate = navigationDelegate
        self.monriApi = monriApi
    }

    func executeIfVc(action: String, _ callable: (ConfirmPaymentControllerViewController) -> Void) {
        guard let vc = vc else {
            logger.info(message: "Tried executing %@, vc is nil", action)
            return
        }

        callable(vc)
    }

    func handleResult(_ response: ConfirmPaymentResponse) {
        logger.trace(message: "Received response %@", response.id)
        guard let vc = vc else {
            logger.fatal(message: "Invoked without available ViewController! Payment id = [%@]", response.id)
            return
        }

        logger.trace(message: "Received response %@", response.id)

        guard let actionRequired = response.actionRequired else {
            logger.fatal(message: "Invoked with nil action required %@", response.id)
            return
        }

        executeIfStatus(InvocationState.CALLBACK_NOT_INVOKED, InvocationState.HANDLE_RESULT, {
            let acsUrl = actionRequired.acsUrl
            guard let redirectUrl = try? URLRequest(url: actionRequired.redirectTo, method: .get) else {
                logger.fatal(message: "Received invalid redirectUrl [%@]", actionRequired.redirectTo)
                return
            }

            navigationDelegate.acsUrl = acsUrl

            logger.info(message: "Handle result invoked with acsUrl = [%@]", acsUrl)

            DispatchQueue.main.async {
                vc.indicator.isHidden = false
                vc.webView.isHidden = true
                vc.webView.load(redirectUrl)
            }
        });

    }

    func executeIfStatus(_ state: InvocationState, _ newState: InvocationState, _ runnable: () -> Void) {
        if (invocationState != state) {
            logger.warn(message: "Tried changing to state = [%@] from state [%@], currentState = [%@]", newState, state, invocationState)
        } else {
            logger.info(message: "Changing state to state = [%@] from currentState = [%@]", newState, state)
            self.invocationState = newState
            runnable()
        }
    }


    enum InvocationState {
        case CALLBACK_NOT_INVOKED,
             THREE_DS_RESULT,
             REDIRECTING_TO_ACS,
             ACS_LOAD_FINISHED,
             ACS_AUTHENTICATION_FINISHED,
             HANDLE_RESULT
    }
}

extension ActionRequiredFlowImpl: TransactionAuthorizationFlowDelegate {

    func threeDs1Result(status: String, clientSecret: String) {
        executeIfVc(action: "threeDs1Result") { vc in
            executeIfStatus(InvocationState.ACS_AUTHENTICATION_FINISHED, InvocationState.THREE_DS_RESULT, {
                logger.info(message: "ThreeDs1Result, status = %@, clientSecret = %@", status, clientSecret);

                DispatchQueue.main.async {
                    vc.indicator.isHidden = false
                    vc.indicator.startAnimating()
                    vc.webView.isHidden = true
                }

                checkPaymentStatus(clientSecret: clientSecret, count: atomicInteger.incrementAndGet())
            })
        }
    }

    func checkPaymentStatus(clientSecret: String, count: Int) {
        if (count >= 3) {
            self.executeIfVc(action: "checkPaymentStatus") { vc in
                vc.paymentStatusRetryExceeded()
            }
        } else {
            monriApi.paymentStatus(PaymentStatusParams(clientSecret: clientSecret)) {
                result in
                self.executeIfVc(action: "paymentStatus") { vc in
                    switch (result) {
                    case .error(let e):
                        self.checkPaymentStatus(clientSecret: clientSecret, count: self.atomicInteger.incrementAndGet())
                    case .result(let r):
                        vc.resultReceived(statusResponse: r);
                    }
                }
            }
        }
    }

    func redirectingToAcs() {
        executeIfVc(action: "redirectingToAcs") { vc in
            executeIfStatus(InvocationState.HANDLE_RESULT, InvocationState.REDIRECTING_TO_ACS, {

                logger.info(message: "redirectingToAcs");

                DispatchQueue.main.async {
                    vc.webView.isHidden = false
                    vc.indicator.isHidden = true
                    vc.indicator.stopAnimating()
                }
            })
        }
    }

    func acsLoadFinished() {
        executeIfVc(action: "acsLoadFinished") { vc in
            executeIfStatus(InvocationState.REDIRECTING_TO_ACS, InvocationState.ACS_LOAD_FINISHED, {

                logger.info(message: "acsLoadFinished");

                DispatchQueue.main.async {
                    vc.webView.isHidden = false
                    vc.indicator.isHidden = true
                    vc.indicator.stopAnimating()
                }
            })
        }
    }

    func acsAuthenticationFinished() {
        executeIfVc(action: "acsAuthenticationFinished") { vc in
            executeIfStatus(InvocationState.REDIRECTING_TO_ACS, InvocationState.ACS_AUTHENTICATION_FINISHED, {

                logger.info(message: "acsAuthenticationFinished");

                DispatchQueue.main.async {
                    vc.webView.isHidden = true
                    vc.indicator.isHidden = false
                    vc.indicator.startAnimating()
                }
            })
        }
    }
}
