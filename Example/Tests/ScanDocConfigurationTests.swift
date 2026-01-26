//
//  ScanDocConfigurationTests.swift
//  Monri
//
//  Created by Karolina Škunca on 25.01.2026..
//  Copyright © 2026 CocoaPods. All rights reserved.
//


import XCTest
@testable import Monri

final class ScanDocConfigurationTests: XCTestCase {

    func testImageConfigurationDefaults() {
        let config = ImageConfiguration(imageCropped: true)

        XCTAssertEqual(config.imageType, ImageTypes.BASE_64)
        XCTAssertTrue(config.imageCropped)
    }

    func testExtractionConfigurationSettingsInitialization() {
        let settings = ExtractionConfigurationSettings(
            shouldReturnDocumentImage: true,
            skipDocumentSizeCheck: false,
            skipImageSizeCheck: true,
            canStoreImages: false,
            dontUseValidation: true
        )

        XCTAssertTrue(settings.shouldReturnDocumentImage)
        XCTAssertFalse(settings.skipDocumentSizeCheck)
        XCTAssertTrue(settings.skipImageSizeCheck)
        XCTAssertFalse(settings.canStoreImages)
        XCTAssertTrue(settings.dontUseValidation)
    }

    func testScanDocExtractionConfigurationInitialization() {
        let imageConfig = ImageConfiguration(imageCropped: false)
        let extractionSettings = ExtractionConfigurationSettings(
            shouldReturnDocumentImage: true,
            skipDocumentSizeCheck: true,
            skipImageSizeCheck: false,
            canStoreImages: true,
            dontUseValidation: false
        )

        let config = ExtractionConfiguration(
            imageConfiguration: imageConfig,
            extractionSettings: extractionSettings,
            acceptTermsAndConditions: true
        )

        XCTAssertEqual(config.imageConfiguration.imageCropped, false)
        XCTAssertTrue(config.extractionConfigurationSettings.canStoreImages)
    }

    func testScanDocValidationConfigurationSetBlurValues() {
        let validationSettings = ValidationConfigurationSettings(skipImageSizeCheck: false)
        var config = ValidationConfiguration(
            blurValues: [0.1, 0.2],
            validationSettings: validationSettings,
            acceptTermsAndConditions: true
        )

        config.setBlurValues([0.5, 0.7])

        XCTAssertEqual(config.blurValues, [0.5, 0.7])
        XCTAssertFalse(config.validationSettings.skipImageSizeCheck)
    }
}
