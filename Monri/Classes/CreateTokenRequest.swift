//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

struct CreateTokenRequest {
    let authenticityToken: String
    let tempCardId: String
    let timestamp: String
    let digest: String
    let token: String
    let paymentMethod: PaymentMethod

    static func from(token: TokenRequest, paymentMethod: PaymentMethod, authenticityToken: String) -> CreateTokenRequest? {
        
        return CreateTokenRequest(authenticityToken: authenticityToken,
                                  tempCardId: token.token,
                                  timestamp: token.timestamp,
                                  digest:token.digest,
                                  token: token.token,
                                  paymentMethod: paymentMethod
        )
    }
    
    private static func expirationDate(card: Card) -> String {
        let month = "\(card.expMonth)".padding(toLength: 2, withPad: "0", startingAt: 0)
        let year = "\(card.expYear - 2000)"
        return "\(year)\(month)"
    }

    func toJson() -> Dictionary<String, Any> {
        let result:[String: Any] = [
            "authenticity_token": authenticityToken,
            "temp_card_id": tempCardId,
            "timestamp": timestamp,
            "digest": digest,
            "token": token
        ]
        return result.merging(paymentMethod.data(), uniquingKeysWith: { (_, new) in new })
    }
}
