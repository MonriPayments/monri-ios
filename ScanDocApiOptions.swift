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
    
    public init(scanDocApiBaseUrl: String, userKey: String, subClient: String) {
        self.scanDocApiBaseUrl = scanDocApiBaseUrl
        self.scanDocUserKey = userKey
        self.scanDocSubKey = subClient
    }
}
