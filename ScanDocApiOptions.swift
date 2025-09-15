//
//  ScanDocApiOptions.swift
//  Monri
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation

public class ScanDocApiOptions {
    public let scanDocApiUrl: String
    public let scanDocUserKey: String
    public let scanDocSubKey: String
    
    public init(scanDocApiUrl: String, scanDocUserKey: String, scanDocSubKey: String) {
        self.scanDocApiUrl = scanDocApiUrl
        self.scanDocUserKey = scanDocUserKey
        self.scanDocSubKey = scanDocSubKey
    }
}
