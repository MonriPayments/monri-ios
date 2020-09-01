//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

class ActionRequiredFlowImpl: ActionRequiredFlow {
    func handleResult(_ response: ConfirmPaymentResponse) {

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
