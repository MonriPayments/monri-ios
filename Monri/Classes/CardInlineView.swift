//
//  CardInlineView.swift
//  Monri
//
//  Created by Jasmin Suljic on 31/10/2019.
//

import UIKit
import Caishen

public class CardInlineView: CardTextField {


    public func getCard() -> Card {
        let card: CaishenCard = self.card
        return Card(number: card.bankCardNumber.rawValue, cvc: card.cardVerificationCode.rawValue, expMonth: Int(card.expiryDate.month), expYear: Int(card.expiryDate.year))
    }
}


public struct MyVisa: Caishen.CardType {

    // MARK: - Required

    // The name of your specified card type:
    public let name = "Visa"

    // Note: The image that will be displayed in the card number text field's image view when this card type has been detected will load from an asset with the name `cardType.name`.

    // If the Issuer Identification Number (the first six digits of the entered card number) of a card number
    // starts with anything from 1000 to 1111, the card is identified as being of type "MyCardType":
    public let identifyingDigits = Set([4])

    // The number of digits expected in the Card Validation Code.
    public let CVCLength = 3

    // MARK: - Optional

    // The grouping of your card number type. The following results in a card number format
    // like "100 - 0000 - 00000 - 000000":
    // Not specifying this will result in a 16 digit number, separated into 4 groups of 4 digits.
    public let numberGrouping = [4, 4, 4, 4, 3]

    /**
     A boolean flag that indicates whether CVC validation is required for this card type or not.
     Setting this value to false will hide the CVC text field from the `CardTextField` and remove the required validation routine. The default is true.
     */
    public let requiresCVC = true

    /**
     A boolean flag that indicates whether expiry validation is required for this card type or not.
     Setting this value to false will hide the month and year text field from the `CardTextField` and remove the required
     validation routine. The default is true.
     */
    public let requiresExpiry = true

    public init() {

    }
}

public struct Maestro: Caishen.CardType {//maestro

    // MARK: - Required

    // The name of your specified card type:
    public let name = "Maestro"

    // Note: The image that will be displayed in the card number text field's image view when this card type has been detected will load from an asset with the name `cardType.name`.

    // If the Issuer Identification Number (the first six digits of the entered card number) of a card number
    // starts with anything from 1000 to 1111, the card is identified as being of type "MyCardType":
    public let identifyingDigits = Set([56, 58, 67, 502, 503, 506, 639, 5018, 620])

    // The number of digits expected in the Card Validation Code.
    public let CVCLength = 3

    // MARK: - Optional

    // The grouping of your card number type. The following results in a card number format
    // like "100 - 0000 - 00000 - 000000":
    // Not specifying this will result in a 16 digit number, separated into 4 groups of 4 digits.
    public let numberGrouping = [4, 4, 4, 4, 3]

    /**
     A boolean flag that indicates whether CVC validation is required for this card type or not.
     Setting this value to false will hide the CVC text field from the `CardTextField` and remove the required validation routine. The default is true.
     */
    public let requiresCVC = true

    /**
     A boolean flag that indicates whether expiry validation is required for this card type or not.
     Setting this value to false will hide the month and year text field from the `CardTextField` and remove the required
     validation routine. The default is true.
     */
    public let requiresExpiry = true

    public init() {

    }
}