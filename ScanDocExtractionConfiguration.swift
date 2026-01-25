//
//  ScanDocExtractionConfiguration.swift
//  Monri
//
//  Created by Karolina Škunca on 25.01.2026..
//

import Foundation

public struct ImageConfiguration {
    let imageType: String
    let imageCropped: Bool
    
    public init(imageCropped: Bool) {
        self.imageType = ImageTypes.BASE_64
        self.imageCropped = imageCropped
    }
}

public struct ExtractionConfigurationSettings {
    let shouldReturnDocumentImage, skipDocumentSizeCheck, skipImageSizeCheck, canStoreImages: Bool
    let dontUseValidation: Bool
    
    public init(shouldReturnDocumentImage: Bool, skipDocumentSizeCheck: Bool, skipImageSizeCheck: Bool, canStoreImages: Bool, dontUseValidation: Bool) {
        self.shouldReturnDocumentImage = shouldReturnDocumentImage
        self.skipDocumentSizeCheck = skipDocumentSizeCheck
        self.skipImageSizeCheck = skipImageSizeCheck
        self.canStoreImages = canStoreImages
        self.dontUseValidation = dontUseValidation
    }
}

public struct ScanDocExtractionConfiguration {
    let imageConfiguration: ImageConfiguration
    let extractionConfigurationSettings: ExtractionConfigurationSettings
    let acceptTermsAndConditions: Bool
    
    public init(imageConfiguration: ImageConfiguration, extractionSettings: ExtractionConfigurationSettings, acceptTermsAndConditions: Bool) {
        self.imageConfiguration = imageConfiguration
        self.extractionConfigurationSettings = extractionSettings
        self.acceptTermsAndConditions = acceptTermsAndConditions
    }
}
