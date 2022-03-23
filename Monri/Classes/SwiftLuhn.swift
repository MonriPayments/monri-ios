//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation




public func cardType(cardNumber: String) -> CardType? {
    let cardType = try? SwiftLuhn.cardType(for: cardNumber)
    return cardType
}

public func suggestedCardType(cardNumber: String) -> CardType? {
    let cardType = try? SwiftLuhn.cardType(for: cardNumber, suggest: true)
    return cardType
}

public func formatCardNumber(_ cardNumber: String) -> String {
    let numbersOnlyEquivalent = cardNumber.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression, range: nil)
    return numbersOnlyEquivalent.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
}


//
//  ObjectiveLuhn.swift
//  Example Project
//
//  Created by Max Kramer on 29/03/2016.
//  Copyright © 2016 Max Kramer. All rights reserved.
//

public enum CardType: Int {
    case amex = 0
    case visa
    case mastercard
    case discover
    case dinersClub
    case jcb
    case maestro
    case rupay
    case mir
    case dinacard
}

public enum CardError: Error {
    case unsupported
    case invalid
}

class SwiftLuhn {


    fileprivate class func regularExpression(for cardType: CardType) -> String {
        switch cardType {
        case .amex:
            return "^3[47][0-9]{5,}$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .jcb:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .mastercard:
            return "^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$"
        case .visa:
            return "^4[0-9]{6,}$"
        case .maestro:
            return "^(5018|5020|5038|6304|6759|6761|6763)[0-9]{8,15}$"
        case .rupay:
            return "^6[0-9]{15}$"
        case .mir:
            return "^220[0-9]{13}$"
        case .dinacard:
            return "^9891[0-9]{12}|^(655670|655671|655672|655673|655674|655675|655676|655677|655678|655679|655680|655681|655682|655683|655684|655685|655686|655687|655688|655689|655690|655691|655692|655693|655694|655695|655696|655697|657371|657372|657373|657374|657375|657376|657377|657378|657379|657380|657381|657382|657383|657384|657385|657386|657387|657388|657389|657390|657391|657392|657393|657394|657395|657396|657397|657398)[0-9]{10}$"
        }
    }

    fileprivate class func suggestionRegularExpression(for cardType: CardType) -> String {
        switch cardType {
        case .amex:
            return "^3[47][0-9]+$"
        case .dinersClub:
            return "^3(?:0[0-5]|[68][0-9])[0-9]+$"
        case .discover:
            return "^6(?:011|5[0-9]{2})[0-9]+$"
        case .jcb:
            return "^(?:2131|1800|35[0-9]{3})[0-9]+$"
        case .mastercard:
            return "^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$"
        case .visa:
            return "^4[0-9]+$"
        case .maestro:
            return "^(5018|5020|5038|6304|6759|6761|6763)[0-9]+$"
        case .rupay:
            return "^6[0-9]+$"
        case .mir:
            return "^220[0-9]+$"
        case .dinacard:
            return "^9891[0-9]+$|^(655670|655671|655672|655673|655674|655675|655676|655677|655678|655679|655680|655681|655682|655683|655684|655685|655686|655687|655688|655689|655690|655691|655692|655693|655694|655695|655696|655697|657371|657372|657373|657374|657375|657376|657377|657378|657379|657380|657381|657382|657383|657384|657385|657386|657387|657388|657389|657390|657391|657392|657393|657394|657395|657396|657397|657398)[0-9]+$"
        }
    }

    class func performLuhnAlgorithm(with cardNumber: String) throws {

        let formattedCardNumber = formatCardNumber(cardNumber)

        guard formattedCardNumber.count >= 9 else {
            throw CardError.invalid
        }

        let originalCheckDigit = formattedCardNumber.last!
        let characters = formattedCardNumber.dropLast().reversed()

        var digitSum = 0

        for (idx, character) in characters.enumerated() {
            let value = Int(String(character)) ?? 0
            if idx % 2 == 0 {
                var product = value * 2

                if product > 9 {
                    product = product - 9
                }

                digitSum = digitSum + product
            } else {
                digitSum = digitSum + value
            }
        }

        digitSum = digitSum * 9

        let computedCheckDigit = digitSum % 10

        let originalCheckDigitInt = Int(String(originalCheckDigit))
        let valid = originalCheckDigitInt == computedCheckDigit

        if valid == false {
            throw CardError.invalid
        }
    }

    class func cardType(for cardNumber: String, suggest: Bool = false) throws -> CardType {
        var foundCardType: CardType?

        for i in CardType.amex.rawValue...CardType.jcb.rawValue {
            let cardType = CardType(rawValue: i)!
            let regex = suggest ? suggestionRegularExpression(for: cardType) : regularExpression(for: cardType)

            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)

            if predicate.evaluate(with: cardNumber) == true {
                foundCardType = cardType
                break
            }
        }

        if foundCardType == nil {
            throw CardError.invalid
        }

        return foundCardType!
    }
}

public extension CardType {
    func stringValue() -> String {
        switch self {
        case .amex:
            return "American Express"
        case .visa:
            return "Visa"
        case .mastercard:
            return "Mastercard"
        case .discover:
            return "Discover"
        case .dinersClub:
            return "Diner's Club"
        case .jcb:
            return "JCB"
        case .maestro:
            return "Maestro"
        case .rupay:
            return "Rupay"
        case .mir:
            return "Mir"
        case .dinacard:
            return "DinaCard"
        }
    }

    init?(string: String) {
        switch string.lowercased() {
        case "american express":
            self.init(rawValue: 0)
        case "visa":
            self.init(rawValue: 1)
        case "mastercard":
            self.init(rawValue: 2)
        case "discover":
            self.init(rawValue: 3)
        case "diner's club":
            self.init(rawValue: 4)
        case "jcb":
            self.init(rawValue: 5)
        case "maestro":
            self.init(rawValue: 6)
        case "rupay":
            self.init(rawValue: 7)
        case "mir":
            self.init(rawValue: 8)
        case "dinacard":
            self.init(rawValue: 9)
        default:
            return nil
        }
    }
}
