//
// Created by Jasmin Suljic on 02/09/2020.
// Copyright (c) 2020 CocoaPods. All rights reserved.
//

import Foundation

public class NewPaymentResponse {
    public let clientSecret: String
    public let status: String

    public init(clientSecret: String, status: String) {
        self.clientSecret = clientSecret
        self.status = status
    }

    public static func fromJson(_ json: Dictionary<String, Any>) -> NewPaymentResponse? {
        
        guard let clientSecret = json["client_secret"] as? String, let status = json["status"] as? String else { return nil }
        return NewPaymentResponse(clientSecret: clientSecret, status: status)
    }
}
