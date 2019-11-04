//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public struct Card {
    public var number: String
    public var cvc: String
    public var expMonth: Int
    public var expYear: Int
    public var tokenizePan: Bool
    
    public var last4: String {
        get {
            if number.count < 4 {
                return number
            } else {
                return String(number.digits.suffix(4))
            }
        }
    }
    
    public var type: CardType? {
        get {
            return cardType(cardNumber: number)
        }
    }

    public init(number: String, cvc: String, expMonth: Int, expYear: Int) {
        self.init(number: number, cvc: cvc, expMonth: expMonth, expYear: expYear, tokenizePan: false)
    }
    
    public init(number: String, cvc: String, expMonth: Int, expYear: Int, tokenizePan: Bool) {
        self.number = number
        self.cvc = cvc
        self.expMonth = expMonth
        self.expYear = expYear
        self.tokenizePan = tokenizePan
    }
    
    public func validateNumber() ->  Bool {
        return isValidCardNumber(number)
    }
    
    public func validateCVC() -> Bool {
        return validateCVV(cvc)
    }
    
    public func validateExpiryDate() -> Bool {
        return validateExpirationDate(month: expMonth, year: expYear) == nil
    }
    
    public func validateCard() -> Bool {
        return validateNumber() && validateCVC() && validateExpiryDate()
    }
    
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
