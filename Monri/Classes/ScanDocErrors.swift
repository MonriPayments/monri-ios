//
//  ScanDocErrors.swift
//  Pods
//
//  Created by Karolina Škunca on 20.01.2026..
//

import Foundation

enum ScanDocErrors: Error {
    case unableToReadExtractedData
    case invalidImageFormat
    case unableToMapResponse
}

extension ScanDocErrors {
    var asNSError: NSError {
        get {
            switch self {
            case .unableToMapResponse:
                return NSError(domain: "Monri ScanDoc: Unable to map response", code: -1002)
            case .invalidImageFormat:
                return NSError(domain: "Monri ScanDoc: Image must be .png or .jpeg format", code: -1001)
            case .unableToReadExtractedData:
                return NSError(domain: "Monri ScanDoc: Extracted data couldn't be read", code: -1000)
            }
        }
    }
}
