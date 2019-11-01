//
//  Number.swift
//  Caishen
//
//  Created by Sagar Natekar on 11/25/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A Number represents the card number of a payment card.
 */
public struct Number: RawRepresentable {

    public typealias RawValue = String

    public let rawValue: String

    /// The number of digits in `self`.
    public var length: Int {
        return rawValue.count
    }
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

}

extension Number: CustomStringConvertible {

    public var description: String {
        return rawValue
    }

}
