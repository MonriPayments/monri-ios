//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public struct TokenRequest {
    let token: String
    let digest: String
    let timestamp: String

    public init(token: String, digest: String, timestamp: String) {
        self.token = token
        self.digest = digest
        self.timestamp = timestamp
    }

    func toJson() -> Dictionary<String, String> {
        return [
            "token": token,
            "digest": digest,
            "timestamp": timestamp
        ]
    }
}