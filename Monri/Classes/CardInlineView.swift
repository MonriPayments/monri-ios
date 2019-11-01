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
