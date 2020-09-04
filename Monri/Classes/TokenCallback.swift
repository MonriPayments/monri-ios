//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public typealias TokenResultCallback = (TokenResult) -> Void

public protocol TokenCallback {
    func onSuccess(_ token: Token)
    func onError(_ error: Error)
}