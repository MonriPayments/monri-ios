//
//  MonriApi.swift
//  Monri
//
//  Created by Jasmin Suljic on 31/10/2019.
//  Copyright © 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation
import Alamofire

public final class MonriApi {

    private let authenticityToken: String
    private let apiUrl: String
    private let tokenizeUrl: String

    public init(authenticityToken: String) {
        self.authenticityToken = authenticityToken
        self.apiUrl = "https://ipgtest.monri.com"
        self.tokenizeUrl = "\(apiUrl)/v2/temp-tokenize"
    }
    
    public func createToken(_ request: TokenRequest, paymentMethod: PaymentMethod, _ callback: @escaping TokenResultCallback) {
        
        guard let createTokenRequest = CreateTokenRequest.from(token: request, paymentMethod: paymentMethod, authenticityToken: authenticityToken) else {
            callback(.error(TokenError.createTokenRequestError))
            return
        }
        
        Alamofire.request(tokenizeUrl, method: .post, parameters: createTokenRequest.toJson(), encoding: JSONEncoding.default)
            .responseJSON { dataResponse in
                guard let data = dataResponse.data else {
                    callback(.error(TokenError.tokenizationFailed))
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        callback(.error(TokenError.jsonParsingError("Converting response = \(data) to JSON failed!")))
                        return
                    }
                    guard let token = Token.fromJson(json) else {
                        callback(.error(TokenError.jsonParsingError("Converting response to Token from \(json) failed!")))
                        return
                    }
                    
                    callback(.token(token))
                } catch {
                    callback(.error(TokenError.jsonParsingError("\(error)")))
                }
        }
    }

    public func createToken(_ request: TokenRequest, card: Card, _ callback: @escaping TokenResultCallback) {

        if let validateTokenRequestResult = validateTokenRequest(request) {
            callback(.error(validateTokenRequestResult))
            return
        }

        if let validateCardResult = validateCard(card) {
            callback(.error(validateCardResult))
            return
        }
        
        return createToken(request, paymentMethod: card, callback)
    }

    private func validateTokenRequest(_ request: TokenRequest) -> TokenError? {
        if request.token.isEmpty {
            return TokenError.invalidTokenRequest(".token empty")
        }

        if request.digest.isEmpty {
            return TokenError.invalidTokenRequest(".digest empty")
        }

        if request.timestamp.isEmpty {
            return TokenError.invalidTokenRequest(".timestamp empty")
        }

        return nil
    }

    private func validateCard(_ card: Card) -> TokenError? {

        if !isValidCardNumber(card.number) {
            return TokenError.invalidCardNumber
        }

        if !validateCVV(card.cvc) {
            return TokenError.invalidCVV
        }

        if let v = validateExpirationDate(month: card.expMonth, year: card.expYear) {
            return v;
        }

        return nil
    }


}
