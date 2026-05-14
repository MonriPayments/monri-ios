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

private let expirationGregorianCalendar: Calendar = {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(identifier: "UTC") ?? .current
    return calendar
}()

private let maxExpirationYearsInFuture = 20

func currentYear() -> Int {
    return expirationGregorianCalendar.component(.year, from: Date())
}

func validateExpirationDate(month: Int, year: Int) -> TokenError? {

    guard month >= 1 && month <= 12 else {
        return TokenError.invalidExpirationMonth
    }

    guard year >= 1000 && year <= 9999 else {
        return TokenError.invalidExpirationYear
    }

    let nowComponents = expirationGregorianCalendar.dateComponents([.year, .month], from: Date())
    guard let currentYearValue = nowComponents.year,
          let currentMonthValue = nowComponents.month else {
        return TokenError.invalidExpirationDate
    }

    if year < currentYearValue {
        return TokenError.invalidExpirationYear
    }

    if year > currentYearValue + maxExpirationYearsInFuture {
        return TokenError.invalidExpirationYear
    }

    if year == currentYearValue && month < currentMonthValue {
        return TokenError.invalidExpirationDate
    }

    return nil
}
