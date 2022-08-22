//
//  CardInlineView.swift
//  Monri
//
//  Created by Jasmin Suljic on 31/10/2019.
//

import UIKit
import Caishen

public class CardInlineView: CardTextField {
    struct CustomCardTypeImageStore: CardTypeImageStore {
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
        cardTypeImageStore = CustomCardTypeImageStore().self as CardTypeImageStore
    }


    public override init(frame: CGRect) {
        super.init(frame: frame)
        cardTypeImageStore = CustomCardTypeImageStore().self as CardTypeImageStore
    }

    public override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        registerCard()
    }

    public func getCard() -> Card {
        let card: CaishenCard = self.card
        return Card(number: card.bankCardNumber.rawValue, cvc: card.cardVerificationCode.rawValue, expMonth: Int(card.expiryDate.month), expYear: Int(card.expiryDate.year))
    }


    private func registerCard() {
        cardTypeRegister.register(cardType: DinaCard())
    }

    public struct DinaCard: Caishen.CardType {
        public let name = "DinaCard"
        public let identifyingDigits = Set([
            655670, 655671, 655672, 655673, 655674, 655675, 655676, 655677, 655678, 655679,
            655680, 655681, 655682, 655683, 655684, 655685, 655686, 655687, 655688, 655689,
            655690, 655691, 655692, 655693, 655694, 655695, 655696, 655697, 657371, 657372,
            657373, 657374, 657375, 657376, 657377, 657378, 657379, 657380, 657381, 657382,
            657383, 657384, 657385, 657386, 657387, 657388, 657389, 657390, 657391, 657392,
            657393, 657394, 657395, 657396, 657397, 657398, 9891
        ])
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
