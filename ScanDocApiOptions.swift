//
//  ScanDocApiOptions.swift
//  Monri
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation

public class ScanDocApiOptions {
    public let scanDocUserKey: String
    public let scanDocSubKey: String
    
    public init(scanDocUserKey: String, scanDocSubKey: String) {
        self.scanDocUserKey = scanDocUserKey
        self.scanDocSubKey = scanDocSubKey
    }
}
