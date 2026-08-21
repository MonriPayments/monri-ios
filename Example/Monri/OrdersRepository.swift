//
// Created by Jasmin Suljic on 02/09/2020.
// Copyright (c) 2020 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import CryptoKit
import Monri

public class OrdersRepository {

    public let authenticityToken: String
    private let key: String
    private let merchantID: String

    public init(authenticityToken: String, key: String, merchantID: String) {
        self.authenticityToken = authenticityToken
        self.key = key
        self.merchantID = merchantID
    }

    var apiOptions: MonriApiOptions {
        MonriApiOptions(authenticityToken: authenticityToken, developmentMode: true, merchantID: merchantID)
    }

    public func createPayment(_ callback: @escaping (NewPaymentResponse?) -> Void) {
        let timestamp = Int(Date().timeIntervalSince1970)
        let orderNumber = "random\(timestamp)"
        
        let parameters: [String: Any] = [
            "amount": 100,
            "order_number": orderNumber,
            "currency": "EUR",
            "transaction_type": "purchase",
            "order_info": "Create payment session order info",
            "scenario": "charge"
        ]
        
        guard let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: []),
              let bodyString = String(data: bodyData, encoding: .utf8) else {
            callback(nil)
            return
        }
        
        // Build digest
        let rawDigest = "\(key)\(timestamp)\(authenticityToken)\(bodyString)"
        
        let digest = SHA512.hash(data: Data(rawDigest.utf8))
        
        let digestHex = digest.map { String(format: "%02x", $0) }.joined()

        let authorizationHeader = "WP3-v2 \(authenticityToken) \(timestamp) \(digestHex)"

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": authorizationHeader
        ]

        let url = "https://ipgtest.monri.com/v2/payment/new"

        guard let requestUrl = URL(string: url) else {
            callback(nil)
            return
        }

        var request = URLRequest(url: requestUrl)
        request.httpMethod = HTTPMethod.post.rawValue
        request.httpBody = bodyData
        for (name, value) in headers.dictionary {
            request.setValue(value, forHTTPHeaderField: name)
        }

        AF.request(request)
        .responseData { dataResponse in
            guard let data = dataResponse.data else {
                callback(nil)
                return
            }
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                    callback(nil)
                    return
                }
                guard let response = NewPaymentResponse.fromJson(json) else {
                    callback(nil)
                    return
                }

                callback(response)
            } catch {
                callback(nil)
            }
        }
    }


}
