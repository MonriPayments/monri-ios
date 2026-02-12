//
//  ValidationConfiguration.swift
//  Pods
//
//  Created by Karolina Škunca on 25.01.2026..
//


public struct ValidationConfiguration {
    var blurValues: [Double]
    let validationSettings: ValidationConfigurationSettings
    
    public init(blurValues: [Double], validationSettings: ValidationConfigurationSettings) {
        self.blurValues = blurValues
        self.validationSettings = validationSettings
    }
    
    public mutating func setBlurValues(_ blurValues: [Double]) {
        self.blurValues = blurValues
    }
}

public struct ValidationConfigurationSettings {
    let skipImageSizeCheck: Bool
    
    public init(skipImageSizeCheck: Bool) {
        self.skipImageSizeCheck = skipImageSizeCheck
    }
}
