//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public enum TokenError: Error {
    case invalidTokenRequest(String)
    case invalidCard(String)
    case invalidCardNumber
    case invalidCVV
    case invalidExpirationMonth
    case invalidExpirationYear
    case invalidExpirationDate
    case createTokenRequestError
    case tokenizationFailed
    case jsonParsingError(String)
    case error(Error)
}

public typealias ValidationError = TokenError;
