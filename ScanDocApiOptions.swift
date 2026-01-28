//
//  ScanDocApiOptions.swift
//  Monri
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation

public class ScanDocApiOptions {
    let scanDocApiBaseUrl: String
    let scanDocUserKey: String
    let scanDocSubKey: String
    let acceptTermsAndConditions: Bool
    
    public init(scanDocApiBaseUrl: String, userKey: String, subClient: String, acceptTermsAndConditions: Bool) {
        self.scanDocApiBaseUrl = scanDocApiBaseUrl
        self.scanDocUserKey = userKey
        self.scanDocSubKey = subClient
        self.acceptTermsAndConditions = acceptTermsAndConditions
    }
}
