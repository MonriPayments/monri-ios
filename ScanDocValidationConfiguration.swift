//
//  ScanDocValidationConfiguration.swift
//  Pods
//
//  Created by Karolina Škunca on 25.01.2026..
//


public struct ScanDocValidationConfiguration {
    let acceptTermsAndConditions: Bool
    var blurValues: [Double]
    let validationSettings: ValidationConfigurationSettings
    
    public init(blurValues: [Double], validationSettings: ValidationConfigurationSettings, acceptTermsAndConditions: Bool) {
        self.blurValues = blurValues
        self.validationSettings = validationSettings
        self.acceptTermsAndConditions = acceptTermsAndConditions
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