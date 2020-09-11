//
// Created by Jasmin Suljic on 01/09/2020.
//

import Foundation

protocol ResultCallback: class {
    associatedtype Result;

    func onSuccess(result: Result)

    func onError(error: Error)

}
