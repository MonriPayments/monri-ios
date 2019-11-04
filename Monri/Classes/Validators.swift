//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public func removeNonDigits(_ val: String) -> String {
    return val.components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
}

public func isValidCardNumber(_ cardNumber: String) -> Bool {
    do {
        try SwiftLuhn.performLuhnAlgorithm(with: cardNumber)
        return true
    } catch {
        return false
    }
}

func validateCVV(_ cvv: String) -> Bool {
    return cvv.count >= 3 && cvv.count <= 4
}

func isInFuture(_ date: Date) -> Bool {
    return date > Date()
}

func currentYear() -> Int {
    let calendar = Calendar.current
    return calendar.component(.year, from: Date())
}

func validateExpirationDate(month: Int, year: Int) -> TokenError? {

    if !(month > 0 && month <= 12) {
        return TokenError.invalidExpirationMonth
    }

    if year < currentYear() {
        return TokenError.invalidExpirationYear
    }

    return nil
}
