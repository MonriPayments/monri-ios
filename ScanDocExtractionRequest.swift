//
//  ScanDocExtractionRequest.swift
//  Pods
//
//  Created by Karolina Škunca on 27.08.2025..
//

import Foundation

// MARK: - ScanDocExtractionRequest
struct ScanDocExtractionRequest: Codable {
    let dataFields: ExtractionDataFields
    let settings: ExtractionSettings
    let acceptTermsAndConditions: Bool

    enum CodingKeys: String, CodingKey {
        case dataFields = "DataFields"
        case settings = "Settings"
        case acceptTermsAndConditions = "AcceptTermsAndConditions"
    }
    
    func toJson() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .useDefaultKeys
        
        guard let data = try? encoder.encode(self),
              let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let jsonDict = jsonObject as? [String: Any] else {
            return [:]
        }
        return jsonDict
    }
}

// MARK: - DataFields
struct ExtractionDataFields: Codable {
    let imageType: String
    let imageCropped: Bool

    enum CodingKeys: String, CodingKey {
        case imageType = "ImageType"
        case imageCropped = "ImageCropped"
    }
}

// MARK: - Settings
struct ExtractionSettings: Codable {
    let shouldReturnDocumentImage, skipDocumentSizeCheck, skipImageSizeCheck, canStoreImages: Bool
    let dontUseValidation: Bool

    enum CodingKeys: String, CodingKey {
        case shouldReturnDocumentImage = "ShouldReturnDocumentImage"
        case skipDocumentSizeCheck = "SkipDocumentSizeCheck"
        case skipImageSizeCheck = "SkipImageSizeCheck"
        case canStoreImages = "CanStoreImages"
        case dontUseValidation = "DontUseValidation"
    }
}
