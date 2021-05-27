//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

public protocol PaymentResultCallback: class {

    func onSuccess(result: PaymentResult)

    func onError(error: Error)

}
