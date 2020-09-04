//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public struct Token {
    public let id: String

    static func fromJson(_ json: Dictionary<String, Any>) -> Token? {

        guard let status = json["status"] as? String else {
            return nil
        }

        if "approved" != status {
            return nil
        }

        guard let id = json["id"] as? String else {
            return nil
        }

        return Token(id: id);
    }
}