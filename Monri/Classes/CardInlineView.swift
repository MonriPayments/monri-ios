//
//  CardInlineView.swift
//  Monri
//
//  Created by Jasmin Suljic on 31/10/2019.
//

import UIKit
import Caishen

public class CardInlineView: CardTextField {
    struct customCardTypeImageStore: CardTypeImageStore {
        func image(for cardType: Caishen.CardType) -> UIImage? {
            switch cardType {
            case is DinaCard:
                return Bundle(for: CardInlineView.self).creditCardImage(for: cardType)
            default:
                return Bundle(for: CardTextField.self).image(for: cardType)
            }
        }

        func cvcImage(for cardType: Caishen.CardType) -> UIImage? {
            Bundle(for: CardTextField.self).image(for: cardType)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cardTypeImageStore = customCardTypeImageStore().self as CardTypeImageStore
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        registerCard()
    }

    public func getCard() -> Card {
        let card: CaishenCard = self.card
        return Card(number: card.bankCardNumber.rawValue, cvc: card.cardVerificationCode.rawValue, expMonth: Int(card.expiryDate.month), expYear: Int(card.expiryDate.year))
    }


    public func registerCard() {
        cardTypeRegister.register(cardType: DinaCard())
    }

    public struct DinaCard: Caishen.CardType {
        public let name = "DinaCard"
        public let identifyingDigits = Set([9891])
        public let CVCLength = 3
        public let numberGrouping = [4, 4, 4, 4]
        public let requiresCVC = true
        public let requiresExpiry = true

        public init() {

        }
    }
}

extension Bundle {
    open func creditCardImage(for cardType: Caishen.CardType) -> UIImage? {
        return UIImage(named: cardType.name, in: self, compatibleWith: nil)
    }

}
