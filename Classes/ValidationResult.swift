//
// Created by Jasmin Suljic on 31/10/2019.
// Copyright (c) 2019 Monri Payments d.o.o. All rights reserved.
//

import Foundation

struct ValidationResult {

    static let valid: ValidationResult = ValidationResult(valid: true, message: nil);

    let valid: Bool
    let message: String?
}
