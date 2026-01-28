//
//  ApplePaymentApiError.swift
//  Pods
//
//  Created by Karolina Škunca on 17.06.2025..
//

import Foundation

public enum ApplePaymentApiError: Error  {
    case requestFailed(String)
    case jsonParsingError(String)
    case unknownError(Error)
}
