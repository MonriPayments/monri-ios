//
//  CVC.swift
//  Caishen
//
//  Created by Sagar Natekar on 11/23/15.
//  Copyright © 2015 Prolific Interactive. All rights reserved.
//

import Foundation

/**
 A CVC (or Card Verification Code) is a security mechanism for online purchases with payment cards.
 - important: You should never save and/or autofill the CVC for a card, as this will void its purpose as a security mechanism.
 - seealso: [Payment Card Industry Data Security Standard](https://www.pcisecuritystandards.org/pdfs/pci_fs_data_storage.pdf)
 */
public struct CVC: RawRepresentable {

    public typealias RawValue = String

    /// The count of digits in the CVC.
    public var length: Int {
        return rawValue.count
    }

    public let rawValue: String

    /**
     Creates a new bank card verification code with the given argument.
     
     - parameter string: The string representation of the CVC.
    */
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    /**
     Parses the CVC to an integer.
     
     - returns: The integer value of the CVC or `nil` if the CVC could not be parsed as integer.
     */
    public func toInt() -> Int? {
        return Int(rawValue)
    }

}

extension CVC: CustomStringConvertible {

    public var description: String {
        return rawValue
    }

}
