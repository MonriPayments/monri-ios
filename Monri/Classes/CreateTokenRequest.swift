//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

struct CreateTokenRequest {
    let authenticityToken: String
    let tempCardId: String
    let timestamp: String
    let pan: String
    let expirationDate: String
    let cvv: String
    let digest: String
    let token: String
    let tokenizePan: Bool

    static func from(token: TokenRequest, card: Card, authenticityToken: String) -> CreateTokenRequest? {
        
        return CreateTokenRequest(authenticityToken: authenticityToken,
                                  tempCardId: token.token,
                                  timestamp: token.timestamp,
                                  pan: card.number,
                                  expirationDate: expirationDate(card: card),
                                  cvv: card.cvc,
                                  digest:token.digest,
                                  token: token.token,
                                  tokenizePan: card.tokenizePan
        )
    }
    
    private static func expirationDate(card: Card) -> String {
        let month = "\(card.expMonth)".padding(toLength: 2, withPad: "0", startingAt: 0)
        let year = "\(card.expYear - 2000)"
        return "\(year)\(month)"
    }

    func toJson() -> Dictionary<String, Any> {
        return [
            "authenticity_token": authenticityToken,
            "temp_card_id": tempCardId,
            "timestamp": timestamp,
            "pan": pan,
            "expiration_date": expirationDate,
            "cvv": cvv,
            "digest": digest,
            "token": token,
            "tokenize_pan": tokenizePan,
        ]
    }
}
