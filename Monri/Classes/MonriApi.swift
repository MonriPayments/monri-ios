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

    public func createToken(_ request: TokenRequest, card: Card, _ callback: @escaping TokenResultCallback) {

        if let validateTokenRequestResult = validateTokenRequest(request) {
            callback(.error(validateTokenRequestResult))
            return
        }

        if let validateCardResult = validateCard(card) {
            callback(.error(validateCardResult))
            return
        }
        
        guard let createTokenRequest = CreateTokenRequest.from(token: request, card: card, authenticityToken: authenticityToken) else {
            callback(.error(ValidationError.createTokenRequestError))
            return
        }
        
        Alamofire.request(tokenizeUrl, method: .post, parameters: createTokenRequest.toJson(), encoding: JSONEncoding.default)
            .responseJSON { dataResponse in
                guard let data = dataResponse.data else {
                    callback(.error(ValidationError.tokenizationFailed))
                    return
                }
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                        callback(.error(ValidationError.jsonParsingError("Converting response = \(data) to JSON failed!")))
                        return
                    }
                    guard let token = Token.fromJson(json) else {
                        callback(.error(ValidationError.jsonParsingError("Converting response to Token from \(json) failed!")))
                        return
                    }
                    
                    callback(.token(token))
                } catch {
                    callback(.error(ValidationError.jsonParsingError("\(error)")))
                }
        }
        
    }

    private func validateTokenRequest(_ request: TokenRequest) -> ValidationError? {
        if request.token.isEmpty {
            return ValidationError.invalidTokenRequest(".token empty")
        }

        if request.digest.isEmpty {
            return ValidationError.invalidTokenRequest(".digest empty")
        }

        if request.timestamp.isEmpty {
            return ValidationError.invalidTokenRequest(".timestamp empty")
        }

        return nil
    }

    private func validateCard(_ card: Card) -> ValidationError? {

        if !isValidCardNumber(card.number) {
            return ValidationError.invalidCardNumber
        }

        if !validateCVV(card.cvc) {
            return ValidationError.invalidCVV
        }

        if let v = validateExpirationDate(month: card.expMonth, year: card.expYear) {
            return v;
        }

        return nil
    }


}
