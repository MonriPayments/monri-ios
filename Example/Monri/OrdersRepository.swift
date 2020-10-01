//
// Created by Jasmin Suljic on 02/09/2020.
// Copyright (c) 2020 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import Monri

public class OrdersRepository {

    public let authenticityToken: String

    public init(authenticityToken: String) {
        self.authenticityToken = authenticityToken
    }

    var apiOptions: MonriApiOptions  {
        MonriApiOptions(authenticityToken: authenticityToken, developmentMode: true)
    }

    public func createPayment(_ callback: @escaping (NewPaymentResponse?) -> Void) {
        Alamofire.request("https://mobile.webteh.hr/example/create-payment-session",
                          method: .post,
//                          parameters: ["skip_authentication":"true"],
                          parameters: [:],
                          encoding: JSONEncoding.default)
                .responseJSON { dataResponse in
                    guard let data = dataResponse.data else {
                        callback(nil)
                        return
                    }
                    do {
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                            callback(nil)
                            return
                        }
                        print(json)
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
