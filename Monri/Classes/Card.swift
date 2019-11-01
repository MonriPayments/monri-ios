//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

public struct Card {
    let number: String
    let cvc: String
    let expMonth: Int
    let expYear: Int

    public init(number: String, cvc: String, expMonth: Int, expYear: Int) {
        self.number = number
        self.cvc = cvc
        self.expMonth = expMonth
        self.expYear = expYear
    }
}
